#!/bin/bash
cd /mnt/Downloads/portage-build-log

rm -f qa_notice.html

echo "<table style='background-color:#FFFF00'>" >> qa_notice.html
echo "<tr>" >> qa_notice.html
echo "<th>QA Notice</th>" >> qa_notice.html
echo "</tr>" >> qa_notice.html

echo "<tr><td>" >> qa_notice.html

files1=($(grep -rl '</span> QA Notice' *))

for f in "${files1[@]}"
do
	info=$(echo "${f}" | awk -F_ '{print $1}')
	echo "${info}_emerge-info.log.html redir qa_notice.html"
	echo "<a href=\"${info}_emerge-info.log.html\">${info}_emerge-info.log.html</a>" >> qa_notice.html
	echo "<br/>" >> qa_notice.html
	echo "${f} redir qa_notice.html"
	echo "<a href=\"${f}\">${f}</a>" >> qa_notice.html
	echo "<br/>" >> qa_notice.html
done

echo "</td></tr>" >> qa_notice.html
echo "</table>" >> qa_notice.html
