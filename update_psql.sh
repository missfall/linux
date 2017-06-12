#!/bin/bash
export PGPASSWORD=my_password    ##PSQL PASSWORD

owner=my_owner            ## PSQL USER
host=my_psql_host_ip/rds-url
admin_user=my_admin
database= my_db

cat tmp | while read line       ## where tmp is file with table names
do

#psql -h $host -U $admin_user -d $database -c "command to execute"
psql -h $host -U $admin_user -d $database -c "ALTER TABLE $line OWNER TO $owner;"

done
