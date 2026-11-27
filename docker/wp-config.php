<?php
// Local Docker configuration. Supply database values through Compose environment variables.
define( 'DB_NAME', getenv( 'WORDPRESS_DB_NAME' ) ?: 'wordpress' );
define( 'DB_USER', getenv( 'WORDPRESS_DB_USER' ) ?: 'wordpress' );
define( 'DB_PASSWORD', getenv( 'WORDPRESS_DB_PASSWORD' ) ?: 'wordpress' );
define( 'DB_HOST', getenv( 'WORDPRESS_DB_HOST' ) ?: 'db:3306' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );

// Development-only salts. Replace these if the stack is ever used beyond local testing.
define( 'AUTH_KEY',         'shoalsaa-local-only-auth-key' );
define( 'SECURE_AUTH_KEY',  'shoalsaa-local-only-secure-auth-key' );
define( 'LOGGED_IN_KEY',    'shoalsaa-local-only-logged-in-key' );
define( 'NONCE_KEY',        'shoalsaa-local-only-nonce-key' );
define( 'AUTH_SALT',        'shoalsaa-local-only-auth-salt' );
define( 'SECURE_AUTH_SALT', 'shoalsaa-local-only-secure-auth-salt' );
define( 'LOGGED_IN_SALT',   'shoalsaa-local-only-logged-in-salt' );
define( 'NONCE_SALT',       'shoalsaa-local-only-nonce-salt' );

$table_prefix = getenv( 'WORDPRESS_TABLE_PREFIX' ) ?: 'wp_';

$local_url = getenv( 'WORDPRESS_HOME' ) ?: 'http://localhost:8080';
define( 'WP_HOME', $local_url );
define( 'WP_SITEURL', getenv( 'WORDPRESS_SITEURL' ) ?: $local_url );
define( 'WP_DEBUG', false );
define( 'FS_METHOD', 'direct' );

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
