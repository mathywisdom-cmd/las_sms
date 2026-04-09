FROM php:8.0-cli

WORKDIR /var/www

# Install system dependencies (FIXED)
RUN apt-get update && apt-get install -y \
    unzip zip git curl libzip-dev libonig-dev libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Fix permissions
RUN chmod -R 775 storage bootstrap/cache

# Clear cached config (VERY IMPORTANT)
RUN rm -f bootstrap/cache/*.php

# Expose port
EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=$PORT
