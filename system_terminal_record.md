- linux 记录操作日志的方法：利用用户切换或者登陆的时候，会自动加载 /etc/profile文件。



export PS1='[\u@\h \w]# '
history
USER_IP=`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`
if [ "$USER_IP" = "" ]
then
        USER_IP=`hostname`
fi
if [ ! -d /opt/history ]
        then
        mkdir /opt/history
        chmod 777 /opt/history
fi
if [ ! -d /opt/history/${LOGNAME} ]
then
        mkdir /opt/history/${LOGNAME}
        chmod 300 /opt/history/${LOGNAME}
fi
export HISTSIZE=4096
DT=`date +"%Y%m%d_%H"`
export HISTFILE="/opt/history/${LOGNAME}/${USER_IP} history.$DT"
chmod 600 /opt/history/${LOGNAME}/*history* 2>/dev/null