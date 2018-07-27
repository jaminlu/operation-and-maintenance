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