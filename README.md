# A Lumen Boilerplate

PHP8 xdebug3 vscode docker on MacOS

**Start project**

```
./start
```

## Architecture

-   nginx
-   php (lumen:8)
-   cache (redis:6)
-   db (mysql:8)
-   adminer

## preinstalled packages

-   illuminate/redis
-   marcha/lumen-routes-list
-   spatie/laravel-permission
-   tymon/jwt-auth

## Tips

1. migrate and seed `./artisan migrate --seed`
1. use `./artisan route:list` to get all routes
1. set `APP_ENV=local` to install `xDebug`
1. open `adminer` from http://localhost:33060/
1. open `phpRedisAdmin` from http://localhost:63790/
