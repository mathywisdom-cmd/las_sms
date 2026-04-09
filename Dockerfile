FROM php:8.0-cli

WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip zip git curl libzip-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy project
COPY . .

# Install dependencies WITHOUT scripts (FIX)
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Permissions
RUN chmod -R 775 storage bootstrap/cache

# Clear cache safely
RUN php artisan config:clear || true
RUN php artisan cache:clear || true

# Expose port
EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=$PORT
