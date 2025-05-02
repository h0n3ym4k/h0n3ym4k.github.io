#!/bin/bash

cd /root

if [ -e /root/world-ing.stop-cron-weekly.enabled ];then
	echo 'stopping weekly - /root/world-ing.stop-cron-weekly.enabled'|mailx root
	exit
fi

emerge --sync --color n
echo;echo;echo;echo "---"
emerge world -Dupv --color n|egrep 'portage' && echo 'compile.sh webalizer'
echo;echo;echo;echo "---"
emerge world -Dupv --color n|egrep 'openssl|gcc|glibc|sources' && echo 'compile.sh webalizer' && echo 'rm build log - rebuild world' && head -n 30 build.log.gen.html.sh
emerge world -Dupv --color y &>/tmp/weekly.txt && cat /tmp/weekly.txt|ansi2html > /tmp/weekly.html && cat /root/gcc-native.txt.html >> /tmp/weekly.html && cat /root/cpuinfo.txt.html >> /tmp/weekly.html && cp -fv /tmp/weekly.html /mnt/Downloads/portage-build-log/weekly.html && mailx -a /tmp/weekly.html -s 'weekly update' 'root@localhost'
echo;echo;echo;echo "---"
#try
#equery l -I \*
