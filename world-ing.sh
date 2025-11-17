#!/bin/bash

cd /root

if [ -e /root/world-ing.stop-cron-weekly.enabled ];then
	echo 'stopping weekly - /root/world-ing.stop-cron-weekly.enabled'|mailx root
	exit
fi

if [ -e /root/world-ing.world-rebuild.enabled ];then
	echo 'Monday after short update THEN world rebuild - need a whole week'|mailx root
fi

emerge --sync --color n
echo;echo;echo;echo "---"
emerge world -Dupv --color n|egrep 'portage' && echo 'compile.sh webalizer'
echo;echo;echo;echo "---"
emerge world -Dupv --color n|egrep 'openssl|gcc|glibc|sources' && echo 'compile.sh webalizer' && echo 'rm build log - rebuild world' && head -n 30 build.log.gen.html.sh
emerge world -Dupv --color y &>/tmp/weekly.txt && cat /tmp/weekly.txt|ansi2html > /tmp/weekly.html && cat /root/gcc-native.txt.html >> /tmp/weekly.html && cat /root/cpuinfo.txt.html >> /tmp/weekly.html && cp -fv /tmp/weekly.html /mnt/Downloads/portage-build-log/weekly.html && mailx -a /tmp/weekly.html -s 'weekly update' 'root@localhost'
echo;echo;echo;echo "---"
emerge world -Dupv --color n &>/tmp/weekly.txt.nocolor && cp -v /tmp/weekly.txt.nocolor /mnt/Downloads
qatom -C `egrep -o '\][[:space:]][[:alnum:]](.*)::gentoo[[:space:]]' /tmp/weekly.txt.nocolor | cut -b1,2 --complement` > /tmp/change.txt && cat /tmp/change.txt |cut -f1,2 -d' '|sed 's/ /\//' >/tmp/qatom-change.txt && cp -v /tmp/qatom-change.txt /mnt/Downloads

#try
#equery l -I \*
