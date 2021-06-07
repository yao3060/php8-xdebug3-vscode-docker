<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    public function run()
    {
        $su = User::query()->where('username', 'super-admin')->first();
        if (!$su) {
            /**@var User $admin */
            $admin = User::create([
                'display_name' => 'SuperAdmin',
                'username' => 'super-admin',
                'email' => 'super-admin@app.com',
                'password' => Hash::make('password')
            ]);
            $admin->assignRole('super-admin');
        }

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
