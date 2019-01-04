#!/bin/bash

#server list
BASE_PATH=$(cd "$(dirname "$0")";pwd)

SEVER_CONF=$BASE_PATH/"iplist"

SERVER_LIST=()
seq=$1
#echo $seq

function menu {
	if [ ! -f $SEVER_CONF ]; then
		echo "Config not found."
		exit 1
	fi
	
	echo '-------------------------'
	count=0
	while read line || [ -n "$line" ]
	do 
	    if [[ ! "$line" =~ ^# ]] && [[  "$line" != "" ]];  then 
		echo [$count] $line 
		SERVER_LIST[$count]=$line 
		let count++
	    fi
	done < $SEVER_CONF
	echo '-------------------------'
	echo -en "请输入\033[32m序号\033[0m选择要登录的服务器: "
	handleChoice;
}


function handleChoice {
	read -n 1 choice
	local lenth=${#SERVER_LIST[@]}
	if [[ "$choice" -lt 0 || "$choice" -gt $lenth ]]; then
	    echo -en "\n\033[31m无效的序号[ $choice ], 是否重新输入( y 是 | n 否 ):\033[0m"
	    read -n 1 retry
		if [[ -n "$retry" && "$retry" = "y" ]]; then
			clear
			menu ;
		else
			echo ""
			exit 1
		fi
	else
		#echo "000"
	    	sshlogin $choice;
	fi	
}


function sshlogin {
	#echo "555"$choice
	#处理iplist里面每一行的字符串，变成数组
	OLD_IFS="$IFS" 
	IFS=" "
	arr=(${SERVER_LIST[$choice]})
	hostname=${arr[0]} 		#first parameter : hostname
	ip=${arr[1]}   		#second parameter: ip
	passwd=${arr[2]}  	#first parameter : password
	username=${arr[3]} 	#fourth parameter: username
	
	$BASE_PATH/goto.exp $ip $username $passwd $hostname
}
menu
#sshlogin
