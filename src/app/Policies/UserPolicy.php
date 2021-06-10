<?php

namespace App\Policies;

use App\Models\User;
use Illuminate\Auth\Access\HandlesAuthorization;

class UserPolicy
{

    use HandlesAuthorization;

    public function list(User $user)
    {
        return $user->hasAnyPermission('list_users');
    }

    public function single(User $user)
    {
        # code...
    }

    public function create(User $user)
    {
        if ($user->hasAnyRole(['super-admin', 'administrator'])) {
            return true;
        }
    }

    public function update(User $currentUser, User $user)
    {
        return $currentUser->id === $user->id;
    }

    public function delete(User $currentUser, User $user)
    {
        return $currentUser->id === $user->id;
    }
}
