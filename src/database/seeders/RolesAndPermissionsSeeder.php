<?php

namespace Database\Seeders;


use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RolesAndPermissionsSeeder extends Seeder
{
    public function run()
    {
        // Reset cached roles and permissions
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        // create permissions
        $permissions = [
            'manage_options',
            'export', 'import',
            'list_users', 'promote_users', 'delete_users', 'edit_users', 'create_users',
            'manage_categories',
            'publish_posts', 'edit_posts', 'edit_published_posts', 'delete_posts',
            'moderate_comments',
            'upload_files',
            'read',
        ];
        foreach ($permissions as $permission) {
            Permission::query()->updateOrCreate(['name' => $permission]);
        }

        // create roles and assign created permissions
        Role::updateOrCreate(['name' => 'subscriber'])
            ->givePermissionTo('read');

        Role::updateOrCreate(['name' => 'author'])
            ->givePermissionTo([
                'upload_files',
                'publish_posts',
                'edit_posts',
                'edit_published_posts'
            ]);

        Role::updateOrCreate(['name' => 'administrator'])
            ->givePermissionTo(Permission::all());
    }
}
