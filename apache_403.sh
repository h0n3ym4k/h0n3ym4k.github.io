#!/bin/bash
#atk pattern > 100

cd /var/log/apache2

zegrep ' 403 ' access_log*|egrep -o '(GET|POST) (.*)'|awk '{ print $1,$2}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'
