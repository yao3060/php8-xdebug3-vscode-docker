<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});

$router->group(['prefix' => 'auth/v1'], function () use ($router) {
    $router->post('register', ['as' => 'auth.register', 'uses' => 'AuthController@register']);
    $router->post('login', ['as' => 'auth.login', 'uses' => 'AuthController@login']);
});


$router->group(['prefix' => 'auth/v1', 'middleware' => 'auth'], function () use ($router) {
    $router->get('me', ['as' => 'auth.me', 'uses' => 'AuthController@me']);
    $router->post('logout', ['as' => 'auth.logout', 'uses' => 'AuthController@logout']);
});