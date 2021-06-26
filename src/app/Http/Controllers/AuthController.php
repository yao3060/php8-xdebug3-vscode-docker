<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redis;

class AuthController extends Controller
{
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct(protected string $tokenCacheKeyPrefix = 'auth:token:')
    {
    }

    public function register(Request $request)
    {
        $request->validate([
            'display_name' => ['required'],
            'username' => ['required', 'min:6', 'unique:users'],
            'email' => ['required', 'email', 'unique:users'],
            'password' => ['required', \Illuminate\Validation\Rules\Password::min(6)]
        ]);

        try {
            $user = User::myCreate($request->only(['display_name', 'username', 'email', 'password']));
            $user->assignRole('subscriber');

            return response()->json([
                'code' => 'registered',
                'message' => 'Register successfully.',
                'data' => $user
            ]);
        } catch (\Throwable $th) {
            return response()->json([
                'code' => 'register_failed',
                'message' => $th->getMessage(),
                'data' => $th->getTrace()
            ]);
        }
    }

    /**
     * @api {post} /auth/v1/login Login
     * @apiName Login
     * @apiGroup Auth
     * @apiDescription get JWT add it to redis cache.
     *
     * @apiParam {String} username   Users username.
     * @apiParam {String} password   Users password.
     *
     * @apiSuccess {String} token JWT.
     */
    public function login(Request $request)
    {
        $credentials = $request->only(['username', 'password']);
        $user = User::where('username', $credentials['username'])->first();

        if ($user && !$user->status && !$token = Auth::attempt($credentials)) {
            return response()->json([
                'code' => 'unauthorized',
                'message' => 'Unauthorized'
            ], 401);
        }

        $cacheKey = $this->tokenCacheKeyPrefix . $user->id;
        if (Redis::hLen($cacheKey) >= 4) {
            $fields = Redis::hKeys($cacheKey);
            Redis::hDel($cacheKey, $fields[0]);
        }
        Redis::hSet($cacheKey, $this->checksum($token), $request->header('user-agent', 'unknown'));

        return $this->respondWithToken($token);
    }

    /**
     * Get the authenticated User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function me()
    {
        return response()->json([
            'code' => 'me',
            'message' => 'Me',
            'data' => Auth::user()
        ]);
    }

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout(Request $request)
    {
        Redis::hDel($this->tokenCacheKeyPrefix . Auth::id(), $this->checksum($request->bearerToken()));

        Auth::logout();

        return response()->json([
            'code' => 'logged_out',
            'message' => 'Successfully logged out'
        ]);
    }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function refresh()
    {
        return $this->respondWithToken(Auth::refresh());
    }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function respondWithToken($token)
    {
        return response()->json([
            'code' => 'get_token_successfully',
            'message' => 'Get token successfully.',
            'data' => [
                'token' => $token,
                'token_type' => 'bearer',
                'expires_in' => Auth::factory()->getTTL() * 3600
            ]
        ]);
    }

    protected function checksum($token)
    {
        return sprintf("%u\n", crc32($token));
    }
}
