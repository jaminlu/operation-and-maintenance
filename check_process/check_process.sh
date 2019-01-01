#!/bin/bash -x

basepath=$(cd `dirname $0`; pwd)

pidfile=$basepath/frontd.pid

log(){
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] $@" >>/tmp/check.log
}

PID=`lsof -i:3000 |awk '{print $2}' |grep -v PID|sort -rn |uniq`
echo $PID > $pidfile

function check_pid() {
        if [ -f $pidfile ];then
                pid=`cat $pidfile`
                if [ -n $pid ]; then
                        running=`ps -p $pid|grep -v "PID TTY" |wc -l`
                        return $running
                fi
        fi
        return 0
}


function process(){
        check_pid
        #running=$?
        echo $running
        if [ $running -gt 0 ];then
                log " the process now is running already, pid=$PID"
        else
                log " the front-monitor process beging to restart..."
                yarn start:prod &
        fi
}

process
