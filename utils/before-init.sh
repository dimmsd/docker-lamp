#!/bin/sh
set -e


if [ $LOG_CLEAR_BEFORE_UP -eq 1 ]
then
    rm -rf /tmp/log-fpm/*
    rm -rf /tmp/log-apache/*
    rm -rf /tmp/log-nginx/*
    rm -rf /tmp/log-xdebug/*
fi

if [ $CLEAR_APACHE_LOG -eq 1 ]
then
    rm -rf /tmp/log-apache/*
fi

