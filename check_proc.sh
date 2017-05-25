#!/bin/sh
# script to check alreay running process

ps -ef | grep '$processname/command' | grep -v 'grep'

if [ `echo $?` -eq 1 ]; then
	dat=`date`

	echo 'starting execution at' $dat    >> /opt/logs/cron.log  2>&1
	nohup  /opt/env/bin/python /opt/env/bin/process & >> /opt/bijou/logs/cron.log 2>&1  #[Enter the command to run the process]
else

	dat=`date`
	newpid=`pgrep -f '$processname/command'`

	val=`ps -p $newpid -o etime=`

	echo -e "process is already running since" $val "!!!!!\n" >> /opt/bijou/logs/cron.log   2>&1
	echo -e 'last checked at' $dat "!!!!\n"  >> /opt/bijou/logs/cron.log   2>&1
	exit 1;

fi
