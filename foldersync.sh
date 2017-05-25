#!/bin/bash
# This script helps to sync remote files
# Script directory

ScriptDir=/home/sanjaym/
 > $ScriptDir/sync_mail.sh.log
 > $ScriptDir/sync.sh.log

echo `date` >> $ScriptDir/sync.sh.log

if [ ! -d $ScriptDir ]
then
        echo -e "!! Error !! $ScriptDir not found.... Exiting at `date`"
        exit 501
fi

cd $ScriptDir
cat sync.sh.config | while read line
do
count=1
echo $line;sleep 3;
sourceip=`echo $line | cut -d ":" -f 1`
sourcedir=`echo $line | cut -d ":" -f 2`
destdir='/opt/Logs/SYNC/'    # destdir location

user='sanjaym'
function rsynclog
{
#logic to sync folders from remote to local server

rsync -aOvz $user@$sourceip:$sourcedir $destdir >> $ScriptDir/sync.sh.log 2>&1
}

rsynclog    # run the sync function

if [ $? -eq 0 ]; then    #check if folder has been synced sucessfully

echo "RSYNC for $sourceip $sourcedir Done. Sucessfully!!!!!!!!"  >> $ScriptDir/sync.sh.log 2>&1
./mail.pl >> $ScriptDir/sync_mail.sh.log 2>&1
else
# Run rsync command again
if [ $count -eq 3 ];then
        echo "RSYNC for $sourceip $sourcedir Failed!!!"  >> $ScriptDir/sync_mail.sh.log 2>&1
else
        count=$((count+1))
        echo INNER ELSE : ATTEMPT NO $count : $line;sleep 2;
        rsynclog
fi
fi
done
./mail.pl >> $ScriptDir/sync.sh.log 2>&1