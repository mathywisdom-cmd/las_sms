FROM php:8.0-cli

WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip zip git curl libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# 🔥 IMPORTANT FIX: skip scripts to avoid ide-helper crash
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Set correct permissions
RUN chmod -R 775 storage bootstrap/cache

# Clear caches safely
RUN php artisan config:clear || true
RUN php artisan cache:clear || true

# Expose port
EXPOSE 10000

# Start Laravel
CMD php artisan serve --host=0.0.0.0 --port=$PORT
