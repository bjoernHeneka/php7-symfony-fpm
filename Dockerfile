FROM php:7-fpm

MAINTAINER Björn Heneka <bheneka@codebee.de>

RUN apt-get update && \
    echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list && \
    apt-get install -y apt-transport-https curl && \
    curl http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN apt-get update && \
    apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
    libcurl4-gnutls-dev \
    zlib1g-dev \
    libicu-dev \
    libmcrypt-dev \
    g++ \
    libxml2-dev \
    libpq-dev \
    vim \
    cron && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) exif
    && docker-php-ext-install -j$(nproc) opcache

ADD symfony.ini /etc/php/7.0/fpm/conf.d/
ADD symfony.ini /etc/php/7.0/cli/conf.d/

ADD symfony.pool.conf /etc/php/7.0/fpm//pool.d/

RUN usermod -u 1000 www-data

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash", "/start.sh"]
