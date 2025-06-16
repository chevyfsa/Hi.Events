#!/bin/bash

cd /app/backend

# Wait for database to be ready
echo "Waiting for database..."
until php artisan migrate --force; do
    echo "Migration failed, retrying in 5 seconds..."
    sleep 5
done

php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan storage:link

# Set proper permissions
chown -R www-data:www-data /app/backend /app/frontend
chmod -R 775 /app/backend/storage /app/backend/bootstrap/cache

# Start Apache in background
apache2-foreground &

# Start supervisor for background jobs
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
