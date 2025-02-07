#!/bin/sh

pgbadger /logs/*.log -o /var/www/html/report.html

nginx -g "daemon off;"