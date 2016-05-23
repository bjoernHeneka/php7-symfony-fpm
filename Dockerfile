FROM php:7-fpm

MAINTAINER Björn Heneka <bheneka@codebee.de>

RUN apt-get update && \
    echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list && \
    apt-get install -y apt-transport-https curl && \
    curl http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN apt-get update && \
    apt-get install -y \
    php-mcrypt \
    php7.0-mysql \
    php7.0-apcu \
    php7.0-gd \
    php7.0-imagick \
    php7.0-curl \
    php7.0-intl \
    php7.0-ldap \
    vim \
    cron && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/*

ADD symfony.ini /etc/php/7.0/fpm/conf.d/
ADD symfony.ini /etc/php/7.0/cli/conf.d/

ADD symfony.pool.conf /etc/php/7.0/fpm//pool.d/

RUN usermod -u 1000 www-data

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/bin/bash", "/start.sh"]