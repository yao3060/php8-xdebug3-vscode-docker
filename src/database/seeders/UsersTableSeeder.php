<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    public function run()
    {
        $admin = User::query()->where('username', 'administrator')->first();
        if (!$admin) {
            /**@var User $admin */
            $admin = User::create([
                'display_name' => 'Admin',
                'username' => 'administrator',
                'email' => 'administrator@app.com',
                'password' => Hash::make('password')
            ]);
            $admin->assignRole('administrator');
        }
    }
}
