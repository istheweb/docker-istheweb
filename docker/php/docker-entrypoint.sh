#!/bin/bash
set -e
echo >&2 "Open docker-entrypoint to $(pwd)"

# if we have a clean repo then install
if ! [ -d vendor ]; then
  composer install
  echo >&2 "add vendor to $(pwd)"
fi

# Generate random key for laravel if it's not specified
php artisan key:generate

# Bring up the initial OctoberCMS database
php artisan october:up

chown -R www-data:www-data /var/www/html
chmod -R 777 /var/www/html

exec "$@"