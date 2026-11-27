# Use the official WordPress image only as a source for the pinned WordPress core.
FROM wordpress:7.1.5-php8.3-apache AS wordpress_source

# PHP runtime pinned to the live site's patch version (8.4.27); update it when the live site's PHP changes.
FROM php:8.4.27-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" gd intl mysqli opcache pdo_mysql zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

COPY --from=wordpress_source --chown=www-data:www-data /usr/src/wordpress/ /var/www/html/
COPY php.ini /usr/local/etc/php/conf.d/wordpress-upload.ini
COPY wp-config.php /usr/local/etc/wordpress/wp-config.php
COPY wordpress-entrypoint.sh /usr/local/bin/wordpress-entrypoint.sh

RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh \
    && chown -R www-data:www-data /var/www/html

ENTRYPOINT ["wordpress-entrypoint.sh"]
CMD ["apache2-foreground"]

EXPOSE 80
