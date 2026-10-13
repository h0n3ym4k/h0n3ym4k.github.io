#!/bin/bash
cd /mnt/Downloads/portage-build-log

rm -f lto_notice.html

echo "<table style='background-color:#03FCEC'>" >> lto_notice.html.tmp.1
echo "<tr>" >> lto_notice.html.tmp.1
echo "<th>gcc -flto=auto</th>" >> lto_notice.html.tmp.1
echo "</tr>" >> lto_notice.html.tmp.1

echo "<tr><td>" >> lto_notice.html.tmp.1

files1=($(egrep -rl ' -flto=auto ' *))

for f in "${files1[@]}"
do
#	info=$(echo "${f}" | awk -F_ '{print $1}')
	info=$(echo "${f}" | rev | cut -f1 -d_ --complement | rev)
	echo "${info}_emerge-info.log.html redir lto_notice.html.tmp.1"
	echo "<a href=\"${info}_emerge-info.log.html\">${info}_emerge-info.log.html</a>" >> lto_notice.html.tmp.1
	echo "<br/>" >> lto_notice.html.tmp.1
	echo "${f} redir lto_notice.html.tmp.1"
	echo "<a href=\"${f}\">${f}</a>" >> lto_notice.html.tmp.1
	echo "<br/>" >> lto_notice.html.tmp.1
done

echo "</td></tr>" >> lto_notice.html.tmp.1
echo "</table>" >> lto_notice.html.tmp.1

cat lto_notice.html.tmp.1 | sort | uniq > lto_notice.html

rm -f lto_notice.html.tmp.1
