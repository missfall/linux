cat All_IP.txt | while read line
        do
                echo $line
                nc -z $line 3389
                if [ $? -eq 0 ]
                then
                echo $line >> WindowsIP.txt
                else
                echo  $line >> LinuxIP.txt
                fi
         done
