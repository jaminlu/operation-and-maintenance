#!/bin/bash -x

chattr -i /etc/passwd
chattr -i /etc/shadow
useradd mysql

args=$@
if [ ! -z "$args" ];then
   ports="$args"
else
   ports=3306
fi

echo ${posts}

server_id=`echo ${HOSTNAME} | sed 's/[a-z|A-Z]//g'`

for port in ${ports}
do
    mkdir -p  /data/mysql
    cp -f my.cnf /etc/my_${port}.cnf
    sed -i 's/3306/'${port}'/g' /etc/my_${port}.cnf
    sed -i 's/110032/'${server_id}'/g'  /etc/my_${port}.cnf   

    cp -f my.sh /usr/local/bin/mysql_${port}.sh
    sed -i 's/3306/'${port}'/g' /usr/local/bin/mysql_${port}.sh
done

chown -R mysql.mysql /data/mysql

#tar -zxf mysql-5.7.19-linux-glibc2.12-x86_64.tar.gz  -C /usr/local
tar -zxf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz  -C /usr/local

cd /usr/local/
#rm -rf mysql
ln -sf mysql-5.7.22-linux-glibc2.12-x86_64 mysql
cd mysql

mkdir /data/mysql/data_${port}
ln -svf /data/mysql/data_${port} /usr/local/mysql/data_${port}
chown -R mysql.mysql /data/mysql/data_${port}

chown -R mysql.mysql .
chown -R mysql.mysql data_*

cd /usr/local/mysql/
for port in ${ports}
do
    bin/mysqld --defaults-file=/etc/my_${port}.cnf  --initialize-insecure
    /usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my_3306.cnf &
    echo "/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my_${port}.cnf --user=mysql &" >> /etc/rc.local
done
