#!/bin/bash
cat /proc/cpuinfo | egrep -m2 'model name|flags' | ansi2html > /root/cpuinfo.txt.html
