FROM php:8.0-cli

WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip zip git curl libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chmod -R 775 storage bootstrap/cache

# Clear cache
RUN php artisan config:clear
RUN php artisan cache:clear

# Expose port
EXPOSE 10000

# ✅ FIXED START COMMAND
CMD php -S 0.0.0.0:10000 -t public
