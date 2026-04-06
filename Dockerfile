FROM php:8.0-cli

WORKDIR /var/www

COPY . .

RUN apt-get update && apt-get install -y \
    unzip zip git curl libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN composer install --ignore-platform-reqs --no-dev

CMD php artisan serve --host=0.0.0.0 --port=10000
