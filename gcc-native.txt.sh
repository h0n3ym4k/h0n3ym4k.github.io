#!/bin/bash
gcc -march=native -mtune=native -E -v - </dev/null 2>&1|egrep -m1 -A1 'COLLECT_GCC_OPTIONS' | ansi2html > /root/gcc-native.txt.html
#gcc -march=native -mtune=native -E -v - </dev/null 2>&1|egrep -m1 -A1 'COLLECT_GCC_OPTIONS'
