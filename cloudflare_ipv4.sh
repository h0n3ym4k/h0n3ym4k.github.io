#!/bin/bash

cd /root/kenchan/webtool101.com

rm apache_log_remoteip.txt
touch apache_log_remoteip.txt

curl --request GET --url "https://api.cloudflare.com/client/v4/ips" --header 'Content-Type: application/json'|jq -r '.result.ipv4_cidrs|.[]' >> apache_log_remoteip.txt
curl --request GET --url "https://api.cloudflare.com/client/v4/ips" --header 'Content-Type: application/json'|jq -r '.result.ipv6_cidrs|.[]' >> apache_log_remoteip.txt

sed -i -e 's/^/RemoteIPTrustedProxy\ /' apache_log_remoteip.txt

echo "RemoteIPHeader CF-Connecting-IP" > apache_log_remoteip_head.txt

cat apache_log_remoteip_head.txt > 1.txt
cat apache_log_remoteip.txt >> 1.txt

cp 1.txt 00_mod_log_cloudflare_remoteip.conf
cp 00_mod_log_cloudflare_remoteip.conf /etc/apache2/modules.d/00_mod_log_cloudflare_remoteip.conf 
