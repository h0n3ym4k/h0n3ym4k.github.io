#!/bin/bash
zcat /var/log/apache2/access_log*|awk '{print $1}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'

echo
zcat /var/log/apache2/access_log*|awk '{print $1}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'|echo -n `awk '{print $2}'` > /tmp/web.txt
echo

for i in $(zcat /var/log/apache2/access_log*|awk '{print $1}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'|awk '{print $2}')
do
	echo
	echo "-- ${i} --"
	zgrep "${i}" /var/log/apache2/access_log*
	echo
	zgrep "${i}" /var/log/apache2/access_log*|wc -l
done
