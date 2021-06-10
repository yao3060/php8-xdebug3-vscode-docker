<?php

namespace Database\Seeders;


use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RolesAndPermissionsSeeder extends Seeder
{
    public function run()
    {
        if (!Role::count()) {
            // Reset cached roles and permissions
            app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

            // create permissions
            $permissions = [
                'manage_options', 'export', 'import',
                'switch_themes', 'edit_dashboard', 'customize',
                'list_users', 'promote_users', 'remove_users', 'edit_users', 'create_users',
                'manage_categories',
                'publish_posts', 'edit_posts', 'delete_posts', 'upload_files',
                'moderate_comments',
                'read',
            ];
            foreach ($permissions as $permission) {
                Permission::query()->updateOrCreate(['name' => $permission]);
            }

            // create roles and assign created permissions
            Role::create(['name' => 'subscriber'])->givePermissionTo('read');

            Role::create(['name' => 'editor'])
                ->givePermissionTo(['publish_posts', 'edit_posts']);

            Role::create(['name' => 'administrator'])->givePermissionTo(Permission::all());
            Role::create(['name' => 'super-admin'])->givePermissionTo(Permission::all());
        }
    }
}
