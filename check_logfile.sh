#!/bin/bash
# Linux script to get last 10 mins logs. this script can be used to monitor any system log files. 
# usage:  ./check_logfile.sh $filename

d1=$(date --date="-10 min" "+%b %_d %H:%M")
d2=$(date "+%b %_d %H:%M")

cat $1 | while read line; do
    [[ $line > $d1 && $line < $d2 || $line =~ $d2 ]] && echo $line
        done
