#!/bin/sh
set -eu

# A named volume mounted at /var/www/html hides files copied there at image build time.
# Initialize a new empty volume from the pinned WordPress core shipped in this image.
if [ ! -f /var/www/html/wp-includes/version.php ]; then
    echo "Initializing WordPress files in persistent volume..."
    tar -c -C /usr/src/wordpress . | tar -x -C /var/www/html
    cp /usr/local/etc/wordpress/wp-config.php /var/www/html/wp-config.php
    chown -R www-data:www-data /var/www/html
fi

exec docker-php-entrypoint "$@"
