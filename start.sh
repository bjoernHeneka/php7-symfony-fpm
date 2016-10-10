#!/bin/bash

/etc/init.d/cron start

# start me
php-fpm -F