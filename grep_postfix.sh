#!/bin/bash
zgrep postfix /var/log/messages*|egrep ' connect from'|awk '{print $8}'|egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'

zgrep postfix /var/log/messages*|egrep ' connect from'|awk '{print $8}'|egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'|awk '{print $2 " REJECT"}' > /tmp/mail.txt

for i in $(zgrep postfix /var/log/messages*|egrep ' connect from'|awk '{print $8}'|egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|sort|uniq -c|sort -h|awk '$1 > 100 {print ;}'|awk '{print $2}')
do
	echo
	echo "-- ${i} --"
	zgrep "${i}" /var/log/messages*
	echo
	zgrep "${i}" /var/log/messages*|wc -l
done
