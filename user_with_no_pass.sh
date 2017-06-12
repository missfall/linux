#!/bin/bash
# Shell script for search for no password entries and lock all accounts

#LOG File
currentdir=`pwd`

LOG="$currentdir/nopassword.log"
STATUS=0
 
echo "Host: $(hostname),  Run date: $(date)" >> $LOG
 
USERS="$(cut -d: -f 1 /etc/passwd)"
 
for u in $USERS
do
  # find out if password is set or not (null password)
   passwd -S $u | grep -Ew "NP" >/dev/null
   if [ $? -eq 0 ]; then # if so 
     echo "$u" >> $LOG 
     passwd -l $u #lock account
     STATUS=1  #update status so that we can send an email
   fi  
done
echo "========================================================" >>$LOG 
if [ $STATUS -eq 1 ]; then
   echo "Please see $LOG file and all account with no password are locked!" 
fi
