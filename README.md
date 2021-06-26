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
-   phpRedisAdmin

## preinstalled packages

-   illuminate/redis
-   spatie/laravel-permission
-   tymon/jwt-auth
-   fruitcake/laravel-cors
-   itsgoingd/clockwork (debug tool, dev only)

## Tips

1. migrate and seed `./artisan migrate --seed`
1. use `./artisan route:list` to get all routes
1. set `APP_ENV=local` to install `xDebug`

## Adminer and phpRedisAdmin

their are mapping to random ports. Please use `docker ps` to find it out.
