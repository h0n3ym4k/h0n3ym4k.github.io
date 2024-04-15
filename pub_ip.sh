#!/bin/bash
egrep -ai ipv4 /mnt/Downloads/pub_ip.txt | egrep -o '[0-9\.][0-9\.]+' | egrep -v '192\.168'
