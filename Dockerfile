FROM php:8.0-cli

WORKDIR /var/www

# Install system dependencies (FIXED for PostgreSQL)
RUN apt-get update && apt-get install -y \
    unzip zip git curl libzip-dev libonig-dev libpq-dev \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader

# Set permissions
RUN chmod -R 775 storage bootstrap/cache

# Expose port
EXPOSE 10000

# IMPORTANT: clear cache at runtime (NOT build time)
CMD php artisan config:clear && php artisan cache:clear && php artisan serve --host=0.0.0.0 --port=$PORT
