#!/bin/bash

cp -f /root/backup.2.sh /tmp
chown root:root /tmp/backup.2.sh
chmod 750 /tmp/backup.2.sh
/tmp/backup.2.sh
