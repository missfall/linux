#!bin/bash

rm -rf /root/windows_server.txt
touch /root/windows_server.txt
rm -rf /root/linux_server.txt
touch /root/linux_server.txt

echo "exit" >> /root/test.txt
file="/tmp/IPFile.txt
while IFS= read line
do

                b=$line
                if [ "$b" = "exit" ]; then
                exit 1
                else
                    open=`nmap -p 3389 $b | grep "3389" | grep open`
                     if [ -z "$open" ]; then
                         echo "Linux Server IP :: $b" >> /root/linux_server.txt
                    else
                    echo "Windows server IP :: $b"    >> /root/windows_server.txt
                     fi
                 fi
done <"$file"
