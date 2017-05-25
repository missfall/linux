#!/bin/bash
arg1=$(date +"%m-%d-%Y-%s")

cp /etc/ssh/sshd_config /etc/ssh/sshd_config_$arg1   # take backup of sshd_conf file
cp /etc/security/access.conf /etc/security/access.conf_$arg1   

echo -n "Enter userid : "
read name
echo -n "Enter usergroup : "
read usergroup
echo -n "Enter User's LAN/VPN IP : "
read ipaddr
echo -n "Enter User's Password : "
read password
echo -n "Enter User's Complete Name : "
read fullname

echo -n "Creating User and assigning permissions Please hold"
echo ""
echo -n "#####"
echo ""
useradd $name
echo -n "##########"
echo ""
echo -n "###############"
echo ""
usermod -g $usergroup $name
usermod -c $fullname $name
echo -n "####################"
echo ""
echo -n "#########################"
echo ""
echo -n "###################################"
echo ""
echo $name":"$password |chpasswd
echo -n "########################################"
echo ""
echo -n "#############################################"
echo ""
(echo $password; echo $password) | smbpasswd -s -a $name
echo -n "##################################################"
echo ""
echo -n "#######################################################"
echo ""
echo "-:$name:ALL EXCEPT $ipaddr" >> /etc/security/access.conf
echo -n "############################################################"
echo ""

allow_users=$(cat /etc/ssh/sshd_config |grep AllowUsers)
allow_users1=$(echo $allow_users $name)
sed  "s/$allow_users/$allow_users1/g" /etc/ssh/sshd_config > /etc/ssh/sshd_inter
echo 'y' |cp /etc/ssh/sshd_inter /etc/ssh/sshd_config
if [ `echo $? -eq 0` ]; then
	echo "User $name successfully added to AllowUsers"
	rm -f sshd_inter
else
	echo "Something went wrong"
	exit 0
fi

echo -n "#################################################################"
echo ""
echo -n "DONE With Configuration changes proceeding with Services Reload"
echo ""
echo -n "######################################################################"
echo ""
echo -n "Reloading SSHD :"
echo ""
echo -n "######################################################################"
echo ""
sshd -t

if [ `echo $? -eq 0` ]; then
	echo ""
	service sshd reload
else
	echo "Something went wrong"
	exit 0
fi

echo -n "######################################################################"
echo ""
echo -n "Reloading SMBD :"
echo ""
service smb reload
echo -n "######################################################################"
echo ""
exit
