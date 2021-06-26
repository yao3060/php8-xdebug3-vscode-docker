<?php

namespace App\Policies;

use App\Enums\PostStatus;
use App\Models\Post;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class PostPolicy
{
    /**
     * Determine if the given post can be updated by the user.
     *
     * @param  \App\Models\User  $user
     * @param  \App\Models\Post  $post
     * @return bool
     */
    public function update(User $user, Post $post)
    {
        // if user don't own this post
        if ($user->id !== $post->user_id) {
            return Response::deny('You do not own this post.');
        }
        // check if the user have the permission to edit post
        if (!$user->hasPermissionTo('edit_posts')) {
            return Response::deny('You can not update post.');
        }

        // is it is published post, check permission: edit_published_posts
        if ($post->status === PostStatus::PUBLISH()->getValue() && !$user->hasPermissionTo('edit_published_posts')) {
            return Response::deny('You can not update published post.');
        }

        return Response::allow();
    }

    public function destroy(User $user, Post $post)
    {
        if ($user->id !== $post->user_id) {
            return Response::deny('You do not own this post.');
        }

        // check if the user have the permission to delete posts
        return $user->hasPermissionTo('delete_posts')
            ? Response::allow()
            : Response::deny('You do not own this post.');
    }
}
