#!/bin/bash

#program entrant - rm -rf /var/log/portage/build - new world <= NEVER scripted this line

rm -f /tmp/mkdir.txt


# w = emerge world -Deu maybe monthly OR gcc/glibc update, no w = emerge world -Du weekly
if [ "${1}" == 'w' ];then
	echo "${1}"
	find /var/log/portage -iname \*.html -exec rm -f {} \;
	rm -rf /mnt/Downloads/portage-build-log
	mkdir /mnt/Downloads/portage-build-log
fi

#step 1 - gen html
cd /var/log/portage/build

files1=($(grep -ril 'Completed installing' *|grep -v html))

#echo "${files1[@]}"

for d in "${files1[@]}"
do
#	c=$(echo "${d}" | awk -F/ '{print $1}')
#	echo "${c}"
#	echo "${d}"

#filename has : - replaced _
	e=$(echo "${d}"|sed s/\:/\_/g)

	if [ -e "${e}".html ];then
		echo "${e} existed"
		continue
	fi
	echo "cat \"${d}\" | ansi2html redir \"${e}\".html"
	cat "${d}" | ansi2html > "${e}".html
done

#step 2 - mkdir
cd /mnt/Downloads/portage-build-log

#echo "${files1[@]}"

for d in "${files1[@]}"
do
	c=$(echo "${d}" | awk -F/ '{print $1}')
	echo "${c}" >> /tmp/mkdir.txt
done

directory=($(cat /tmp/mkdir.txt | sort | uniq))
#echo "mkdir ${directory[@]}"
mkdir "${directory[@]}"

#step 3 - cannot rsync - cp only
for d in "${directory[@]}"
do
#	echo "rsync -avz /var/log/portage/build/${d}/*.html /mnt/Downloads/${d}"
#	rsync -avz --dry-run /var/log/portage/build/${d}/*.html /mnt/Downloads/portage-build-log/${d}
#	rsync -avz /var/log/portage/build/${d}/*.html /mnt/Downloads/portage-build-log/${d}
	cp -nv /var/log/portage/build/"${d}"/*.html /mnt/Downloads/portage-build-log/"${d}"/
done

#step 4 - summary.log
cd /var/log/portage/elog/
cat `ls --hide=\*.gz /var/log/portage/elog/` > /tmp/01summary.log
cp -v /tmp/01summary.log /mnt/Downloads/portage-build-log/01summary.log

#step 5 - genkernel.log
cat /var/log/genkernel.log | ansi2html > /mnt/Downloads/portage-build-log/genkernel.log.html

#step 6 - emerge --info
cd /mnt/Downloads/portage-build-log

for p in $(equery list -F'$cp' \*|uniq)
do
	cd $(echo "${p}" | awk -F/ '{print $1}')
#	emerge --info "${p}" > "$(echo \"${p}\" | awk '{print $2}')"_emerge-info.log

	for q in $(equery list "${p}"|uniq)
	do

pkg=`equery l -F'$cp' "${p}"|uniq`
pkgr=`equery l -F'$name-$fullversion' "${q}"`

#echo "${pkg[@]}"
#echo "${pkgr[@]}"

if [ -e "${pkgr}"_emerge-info.log.html ];then
  echo "${pkgr}_emerge-info.log.html existed"
  continue
fi

echo "emerge --info ${pkg} --color y | ansi2html redir ${pkgr}_emerge-info.log.html"
emerge --info "${pkg}" --color y | ansi2html > "${pkgr}"_emerge-info.log.html
	done

	cd /mnt/Downloads/portage-build-log
done

#step 7 - https://h0n3ym4k.github.io/portage-build-log/index.html
cd /mnt/Downloads/portage-build-log

echo "<!DOCTYPE html>" > index.html.tmp.1
echo "<html lang="en">" >> index.html.tmp.1

echo "<head>" >> index.html.tmp.1

echo "<meta name='msvalidate.01' content='0A3812A6FD3C7090D7E4D2F5CED667E9'/>" >> index.html.tmp.1

echo "<meta charset='UTF-8'/>" >> index.html.tmp.1
echo "<meta name='viewport' content='width=device-width, initial-scale=1'/>" >> index.html.tmp.1
echo "<meta name='description' content='Gentoo build log, any help, support smiles'/>" >> index.html.tmp.1

echo "<meta property='og:url' content='https://h0n3ym4k.github.io/portage-build-log'/>" >> index.html.tmp.1
echo "<meta property='og:type' content='article'/>" >> index.html.tmp.1
echo "<meta property='og:title' content='Superscale.systems - Freelance'/>" >> index.html.tmp.1
echo "<meta property='og:description' content='Gentoo build log, emerge --info'/>" >> index.html.tmp.1
echo "<meta property='og:image' content='https://h0n3ym4k.github.io/mermaid-diagram-20220613090237.png'/>" >> index.html.tmp.1

echo "<title>Gentoo build log</title>" >> index.html.tmp.1

echo "</head>" >> index.html.tmp.1

echo "<body>" >> index.html.tmp.1

echo "<center><h1>Gentoo build.log</h1></center>" >> index.html.tmp.1

echo "<style>" >> index.html.tmp.1
echo " .blink {" >> index.html.tmp.1
echo "   animation: blinker 0.6s linear infinite;" >> index.html.tmp.1
echo "   color: #1c87c9;" >> index.html.tmp.1
echo "   font-size: 30px;" >> index.html.tmp.1
echo "   font-weight: bold;" >> index.html.tmp.1
echo "   font-family: sans-serif;" >> index.html.tmp.1
echo " }" >> index.html.tmp.1
echo " @keyframes blinker {" >> index.html.tmp.1
echo "   50% {" >> index.html.tmp.1
echo "     opacity: 0;" >> index.html.tmp.1
echo "   }" >> index.html.tmp.1
echo " }" >> index.html.tmp.1
echo "</style>" >> index.html.tmp.1
echo "<center><h2><p class='blink'>if you cannot resist your own temptation coming to this page,<br/>pls scroll down all the way</p></h2></center>" >> index.html.tmp.1

#echo "<a href="https://ko-fi.com/98036119lmak">https://ko-fi.com/98036119lmak - Support smile</a>" >> index.html.tmp.1
echo "<iframe id='kofiframe' src='https://ko-fi.com/98036119lmak/?hidefeed=true&widget=true&embed=true&preview=true' style='border:none;width:100%;padding:4px;background:#f9f9f9;' height='712' title='98036119lmak'></iframe>" >> index.html.tmp.1

echo "<iframe id='fbiframe' src='https://h0n3ym4k.github.io/fb.html' width='100%' height='400px' style='border:0' title='fb msg'></iframe>" >> index.html.tmp.1

#echo "<iframe id='note/error build log list/link, emerge-info' src='https://h0n3ym4k.github.io/note.html'></iframe>" >> index.html.tmp.1 = manual process, never scripted this line/process for error builds

echo "<center><h2>weekly-to-monthly update unless gcc/glibc/kernel will update world</h2></center>" >> index.html.tmp.1

d=$(date '+%a %F')
echo "<center><h2>Last update: ${d}</h2></center>" >> index.html.tmp.1

echo "<center><h3>any help needed or your support is appreciated. Msg right away!</h3></center>" >> index.html.tmp.1

echo "<!-- error - red -->" >> index.html.tmp.1
echo "" >> index.html.tmp.1
echo "<!-- QA Notice - yellow -->" >> index.html.tmp.1
echo "" >> index.html.tmp.1

#$(qa_notice.sh) - should run by hand manually, NEVER run in script-ed - static process
if [ -e qa_notice.html ];then
	cat qa_notice.html >> index.html.tmp.1
fi

echo "<center><h3>All logs, in general</h3></center>" >> index.html.tmp.1
echo "<br/>" >> index.html.tmp.1
echo "<a href="genkernel.log.html">genkernel.log.html - genkernel - kernel build log</a>" >> index.html.tmp.1
echo "<br/>" >> index.html.tmp.1
echo "<a href="01summary.log">01summary.log</a>" >> index.html.tmp.1
echo "<br/>" >> index.html.tmp.1

files2=($(find -iname \*.html ! -iname \*emerge-info.log.html|cut -b1,2 --complement))
for f in "${files2[@]}"
do
	info=$(echo "${f}" | rev | cut -d_ -f1 --complement | rev)
	echo "<a href=\"${info}_emerge-info.log.html\">${info}_emerge-info.log.html</a>" >> index.html.tmp.2
	echo "<br/>" >> index.html.tmp.2
	echo "<a href=\"${f}\">${f}</a>" >> index.html.tmp.2
	echo "<br/>" >> index.html.tmp.2
done

echo "<center><h2>if you have come to this far,<br/>pls consider buying me a coffee</h2></center>" >> index.html.tmp.3

echo "</body>" >> index.html.tmp.3
echo "</html>" >> index.html.tmp.3

cat index.html.tmp.1 > index.html
cat index.html.tmp.2 | sed s/\:/\_/g >> index.html
cat index.html.tmp.3 >> index.html
rm -f index.html.tmp.1 index.html.tmp.2 index.html.tmp.3

echo "index.html generated"
