#!/bin/bash

if [ "${1}" == 'w' ];then
	echo "${1}"
	rm -rf /mnt/Downloads/elfcat-build-log
fi

cd /
mkdir /mnt/Downloads/elfcat-build-log
#bin dev home lib64 media opt root run tmp var boot etc lib lost+found mnt proc root.dist sbin sys usr
#except other dir

#for d in bin lib64 opt lib sbin usr
#do
#	echo "-- ${d} --"
files=($(find /bin /lib64 /opt /lib /sbin /usr -exec eu-elfclassify --executable --print {} \;))
#	find /${d} -exec eu-elfclassify --executable --print {} \;
#	files[${#files[@]}]="$(find /${d} -exec eu-elfclassify --executable --print {} \;)"
#	echo "${files[1]}"
#done

cd /mnt/Downloads/elfcat-build-log
for f in "${files[@]}"
do
	name=$(echo "${f}"|sed 's/\//\_/g')
	nametail=$(echo "${f}"|rev|cut -f1 -d/|rev)
	echo "name: ${name}"
	echo "f: ${f}"
	echo "nametail: ${nametail}"
	echo "elfcat ONLY works with .html, shxt"
	echo "/root/.cargo/bin/elfcat ${f}"
	echo " RENAME to ${name}.html"
	/root/.cargo/bin/elfcat ${f} && mv ${nametail}.html ${name}.html
	echo "--"
done

cd /mnt/Downloads/elfcat-build-log

echo "<!DOCTYPE html>" > index.html.tmp.1
echo "<html lang="en">" >> index.html.tmp.1

echo "<head>" >> index.html.tmp.1

echo "<meta name='msvalidate.01' content='0A3812A6FD3C7090D7E4D2F5CED667E9'/>" >> index.html.tmp.1

echo "<meta charset='UTF-8'/>" >> index.html.tmp.1
echo "<meta name='viewport' content='width=device-width, initial-scale=1'/>" >> index.html.tmp.1
echo "<meta name='description' content='elfcat build log, any help, support smiles'/>" >> index.html.tmp.1

echo "<meta property='og:url' content='https://h0n3ym4k.github.io/elfcat-build-log'/>" >> index.html.tmp.1
echo "<meta property='og:type' content='article'/>" >> index.html.tmp.1
echo "<meta property='og:title' content='Superscale.systems - Freelance'/>" >> index.html.tmp.1
echo "<meta property='og:description' content='elfcat build log'/>" >> index.html.tmp.1
echo "<meta property='og:image' content='https://h0n3ym4k.github.io/mermaid-diagram-20220613090237.png'/>" >> index.html.tmp.1

echo "<title>elfcat build log</title>" >> index.html.tmp.1

echo "</head>" >> index.html.tmp.1

echo "<body>" >> index.html.tmp.1

echo "<center><h1>elfcat build.log</h1></center>" >> index.html.tmp.1

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

echo "<iframe id='kofiframe' src='https://ko-fi.com/98036119lmak/?hidefeed=true&widget=true&embed=true&preview=true' style='border:none;width:100%;padding:4px;background:#f9f9f9;' height='712' title='98036119lmak'></iframe>" >> index.html.tmp.1

echo "<center><h2><a href="https://m.me/freelance.setup.linux" target="_blank"><img src="/fb.png" height="80" width="80">facebook messenger page</a></h2></center>" >> index.html.tmp.1

echo "<center><h2>weekly-to-monthly update unless gcc/glibc/kernel will update world</h2></center>" >> index.html.tmp.1

d=$(date '+%a %F')
echo "<center><h2>Last update: ${d}</h2></center>" >> index.html.tmp.1

echo "<center><h3>any help needed or your support is appreciated. Msg right away!</h3></center>" >> index.html.tmp.1

echo "<center><h3>All logs, in general</h3></center>" >> index.html.tmp.1
echo "<br/>" >> index.html.tmp.1

files2=($(find -size -94M -iname \*.html ! -iname index.html))
for f in "${files2[@]}"
do
#	name=$(echo ${f}|rev|cut -d/ -f1|rev)
#	echo "<a href=\"${name}\">\"${name}\"</a>" >> index.html.tmp.2
	fname=$(echo ${f}|cut -b1,2 --complement)
	echo ${fname}
	echo "<a href=\"${fname}\">\"${fname}\"</a>" >> index.html.tmp.2
	echo "<br/>" >> index.html.tmp.2
done

echo "<center><h2>if you have come to this far,<br/>pls consider buying me a coffee</h2></center>" >> index.html.tmp.3

echo "</body>" >> index.html.tmp.3
echo "</html>" >> index.html.tmp.3

cat index.html.tmp.1 > index.html
cat index.html.tmp.2 >> index.html
cat index.html.tmp.3 >> index.html
rm -f index.html.tmp.1 index.html.tmp.2 index.html.tmp.3

#github cannot >100M per file each
find -size +94M -iname \*.html -ls >/tmp/elfcat.m+94.log
find -size +94M -iname \*.html ! -iname index.html -exec rm -f {} \;

echo "index.html generated"

echo "${files[1]}"
echo "${files[10]}"
echo "${files[200]}"
echo "${files[300]}"
echo "${files[400]}"
