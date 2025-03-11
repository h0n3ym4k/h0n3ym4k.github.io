#!/bin/bash

cd /tmp

#/mnt/Downloads/StoneStepsWebalizer-6-3-0.tar.gz
crontab -l | gzip > /mnt/Downloads/cron.gz
tar czpf /mnt/Downloads/etc.tar.gz /etc
tar czpf /mnt/Downloads/home.tar.gz /home
tar czpf /mnt/Downloads/htdocs.tar.gz /var/www/localhost/htdocs
#/mnt/Downloads/kali-user.tar.gz
tar czpf /mnt/Downloads/root.tar.gz /root 2>/dev/null

echo
echo "google drive => work => g64-kenchan"
echo
