#!/bin/bash


log(){
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] $@" >>/tmp/check.log
}

#check httpd daemon exists
ps -ef |grep httpd |grep -v grep
if [ $? -ne 1 ]
then 
        log "now stop httpd daemon"
        service httpd stop
else 
        log "the httpd daemon now is stopped"
fi


#check nginx daemon
ps -ef |grep nginx |grep -v grep
if [ $? -ne 0 ]
then
        log "begin to start nginx...."
        cd /usr/local/nginx/sbin/nginx && ./nginx &
else
        log "nginx is normal "
fi





#!/bin/bash
log(){
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] $@" >>/tmp/check.log
}


hostname=`hostname`

text=("openssl exit with orphan rings")
logfile="/var/log/messages"
num=`grep -o -E "${text[0]}" $logfile|sort |uniq -c|awk '{print $1}'`

if [ $num > 10 ]; then
        curl -s $DINGDING_API -H 'Content-Type: application/json'   -d '{"msgtype": "text","text": {"content": "'$hostname' intel QAT card may crash"}}'
        log "The intel QAT card may be crash !" 
        log "begin to restart qat driver and nginx daemon !"
        pkill -9 nginx
        service qat_service restart
        cd /usr/local/nginx/sbin/  && ./nginx &
else 
        log "The interl QAT card work normally."    
fi



