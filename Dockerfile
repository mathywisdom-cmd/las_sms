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

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set correct permissions
RUN chmod -R 775 storage bootstrap/cache

# Generate Laravel caches (important for production)
RUN php artisan config:clear
RUN php artisan cache:clear

# Expose dynamic port
EXPOSE 10000

# Start Laravel (IMPORTANT: use $PORT)
CMD php artisan serve --host=0.0.0.0 --port=$PORT
