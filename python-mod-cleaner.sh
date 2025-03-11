#!/bin/bash
for p in $(equery -q l dev-python/\*)
do
	echo "emerge -1 `equery l -F'$cp' ${p}`"
	emerge -1pv `equery l -F'$cp' ${p}`
done
