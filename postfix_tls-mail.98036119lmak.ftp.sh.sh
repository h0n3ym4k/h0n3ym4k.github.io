#!/bin/bash
cd /root
cat /root/.acme.sh/mail.98036119lmak.ftp.sh_ecc/mail.98036119lmak.ftp.sh.key /root/.acme.sh/mail.98036119lmak.ftp.sh_ecc/mail.98036119lmak.ftp.sh.cer /root/.acme.sh/mail.98036119lmak.ftp.sh_ecc/fullchain.cer > /root/postfix_tls.pem
chmod 600 /root/postfix_tls.pem
chown root:root /root/postfix_tls.pem
rsync -avz /root/postfix_tls.pem /etc/postfix
/etc/init.d/postfix restart
