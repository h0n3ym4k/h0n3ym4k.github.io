#!/bin/bash

cd /root

if [ -e /root/world-ing.stop-cron-weekly ];then
	echo 'stopping weekly - /root/world-ing.stop-cron-weekly'
	exit
fi

emerge --sync --color n
echo;echo;echo;echo "---"
emerge world -Dupv --color n|egrep 'gcc|glibc|sources'
emerge world -Dupv --color y|ansi2html > /tmp/weekly.html && mailx -a /tmp/weekly.html -s 'weekly update' 'root@localhost'
