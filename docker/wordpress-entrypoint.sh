#!/bin/sh
set -eu

# A named volume mounted at /var/www/html hides files copied there at image build time.
# Initialize a new empty volume from the pinned WordPress core shipped in this image.
if [ ! -f /var/www/html/wp-includes/version.php ]; then
    echo "Initializing WordPress files in persistent volume..."
    tar -c -C /usr/src/wordpress . | tar -x -C /var/www/html
    chown -R www-data:www-data /var/www/html
fi

# Always ensure the persistent volume has the custom Compose configuration.
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing wp-config.php into persistent volume..."
    cp /usr/local/etc/wordpress/wp-config.php /var/www/html/wp-config.php
    chown www-data:www-data /var/www/html/wp-config.php
fi

# Install a local admin account once, only when Compose supplies bootstrap credentials
# and WordPress has no installed site yet. Existing sites are never modified here.
if [ -n "${WORDPRESS_ADMIN_USER:-}" ] && [ -n "${WORDPRESS_ADMIN_PASSWORD:-}" ]; then
    if ! php -r 'define("WP_INSTALLING", true); $_SERVER["HTTP_HOST"]="localhost"; $_SERVER["REQUEST_URI"]="/"; $_SERVER["SERVER_PORT"]="80"; require "/var/www/html/wp-load.php"; exit( is_blog_installed() ? 0 : 1 );' >/dev/null 2>&1; then
        echo "Waiting for MySQL before first-time WordPress setup..."
        until php -r 'define("WP_INSTALLING", true); $_SERVER["HTTP_HOST"]="localhost"; $_SERVER["REQUEST_URI"]="/"; $_SERVER["SERVER_PORT"]="80"; require "/var/www/html/wp-load.php";' >/dev/null 2>&1; do
            sleep 3
        done

        php -r '
            define( "WP_INSTALLING", true );
            $_SERVER["HTTP_HOST"] = "localhost";
            $_SERVER["REQUEST_URI"] = "/";
            $_SERVER["SERVER_PORT"] = "80";
            require "/var/www/html/wp-load.php";
            if ( ! is_blog_installed() ) {
                require_once ABSPATH . "wp-admin/includes/upgrade.php";
                $result = wp_install(
                    getenv("WORDPRESS_BLOG_TITLE") ?: "ShoalsAA Local Test",
                    getenv("WORDPRESS_ADMIN_USER"),
                    getenv("WORDPRESS_ADMIN_EMAIL") ?: "admin@example.invalid",
                    true,
                    "",
                    getenv("WORDPRESS_ADMIN_PASSWORD")
                );
                if ( is_wp_error( $result ) ) {
                    fwrite( STDERR, $result->get_error_message() . PHP_EOL );
                    exit( 1 );
                }
                echo "Created the configured local WordPress administrator.\\n";
            }
        '
    fi
fi

exec docker-php-entrypoint "$@"
