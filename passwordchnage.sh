#!/bin/sh


cat server.txt | while read line
        do
		user=sanjaym
                cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w 15| head -n 1 > temp   # Generate the Random password
                 password=`cat temp`
                 # echo $password
               ssh -n $line "(echo $password; echo $password) | passwd $user"
                echo $line " : " $password >> password.txt

        done
