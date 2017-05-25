#!/bin/bash 

ScriptDir=/opt/AutoBackup
DataDir=/opt/AutoBackup/Data
ConfigFile=/opt/AutoBackup/AutoBackup.sh.config

if [ ! -d $ScriptDir ] || [ ! -d $DataDir ] || [ ! -f $ConfigFile ]
then
echo "One of the config Dir / File missing.... Exiting at `date`"
exit
fi

cd $ScriptDir
if [ $? -ne 0 ]
then
echo "Unable to change script directory $ScriptDir.... Exiting at `date`"
exit
fi

echo > AutoBackup.sh.log 2>&1

echo "#### Starting Backup Of Backup at `date` ####" >> AutoBackup.sh.log 2>&1

rsync -e "ssh -q" -av --delete /opt/AutoBackup/Data/ /opt/AutoBackup/BackupOfData 1> /dev/null 2>> AutoBackup.sh.log

echo "#### Finished Backup Of Backup at `date` ####" >> AutoBackup.sh.log 2>&1

echo >> AutoBackup.sh.log 2>&1
echo >> AutoBackup.sh.log 2>&1

echo "#### Starting Linux Server's Backup Process at `date` ####" >> AutoBackup.sh.log 2>&1
echo >> AutoBackup.sh.log 2>&1
echo >> AutoBackup.sh.log 2>&1
echo >> AutoBackup.sh.log 2>&1

IFS=$(echo -en "\n\b")

for ServerDetails in `cat AutoBackup.sh.config | grep -v ^#`
do
	ServerIP=`echo -e "$ServerDetails" | awk 'BEGIN {FS=";"} {print $1}'`
	SourceDir=`echo -e "$ServerDetails" | awk 'BEGIN {FS=";"} {print $2}'`
	DestDir=`echo -e "$ServerDetails" | awk 'BEGIN {FS=";"} {print $3}'`
	ExcludeDir=`echo  "$ServerDetails" | awk 'BEGIN {FS=";"} {print $4}'`
	
	echo "==== Starting $ServerIP Server's Backup Process for $SourceDir at `date` ====" >> AutoBackup.sh.log 2>&1
	echo >> AutoBackup.sh.log 2>&1
	echo "Checking Backup Configuration file for Source & Destination Dir at `date`" >> AutoBackup.sh.log 2>&1
	if [ `echo -e "$SourceDir" | grep /$ > /dev/null 2>&1; echo $?` -eq 0 ] || [ "$DestDir" != "$DataDir/$ServerIP" ]
	then
	echo "!! Error !! Either source directory ending with / OR destination dir is not set to $DataDir/$ServerIP !! Error !!"  >> AutoBackup.sh.log 2>&1
	else
		echo "Source and Destination directories are OK. Checking exclude dir configuration.... at `date`" >> AutoBackup.sh.log 2>&1
		if [ -z "$ExcludeDir" ]
		then
			echo "Exclude directory configuration NOT found.... at `date`" >> AutoBackup.sh.log 2>&1
			echo "Starting backup of $SourceDir to ./Data/$ServerIP without excluding any direcotry at `date`" >> AutoBackup.sh.log 2>&1
			echo >> AutoBackup.sh.log 2>&1
			rsync -e "ssh -q" -avzR --delete `echo -e $ExcludeDir` root@$ServerIP:$SourceDir $DestDir 1> /dev/null 2>> AutoBackup.sh.log
			echo >> AutoBackup.sh.log 2>&1
		else	
			> exclude.conf.temp

			for (( n=1; n<=`echo -e "$ExcludeDir" | awk 'BEGIN { FS="," } { print NF }'`; n++ ))
			do
				echo -e "$ExcludeDir" | awk -v VAR=${n} 'BEGIN { FS="," }{ print $VAR }' >> exclude.conf.temp
			done

			echo "Exclude directory configuration found.... at `date`" >> AutoBackup.sh.log 2>&1
			echo "Starting backup of $SourceDir to ./Data/$ServerIP with excluding $ExcludeDir at `date`" >> AutoBackup.sh.log 2>&1
			echo >> AutoBackup.sh.log 2>&1
			rsync -e "ssh -q" -avzR --delete-excluded --exclude-from=exclude.conf.temp root@$ServerIP:$SourceDir $DestDir 1> /dev/null 2>> AutoBackup.sh.log
			echo >> AutoBackup.sh.log 2>&1
		fi
	fi
	echo "==== Finished $ServerIP Server's Backup Process for $SourceDir at `date` ====" >> AutoBackup.sh.log 2>&1
	echo >> AutoBackup.sh.log 2>&1
	echo >> AutoBackup.sh.log 2>&1

done
echo "#### Finished Linux Server's Backup Process at `date` ####" >> AutoBackup.sh.log 2>&1
