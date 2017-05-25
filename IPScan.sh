#!/bin/bash
cat IP.txt | while read line
    do
    echo $line
    ping -c2 $line;
    if [ $? = 0 ]; then
    echo $line >>  Pingout.txt;
fi
done
