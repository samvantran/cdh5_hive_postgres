#!/bin/bash
set -x
#save all env vars .bashrc for ssh sessions
printenv | cat >> /root/.bashrc

# hadoop bootstrap
/etc/hadoop-bootstrap.sh -d

#restart postgresql
sudo /etc/init.d/postgresql restart

# create hdfs directories
$HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root &&\
 $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /apps/hive/warehouse

# altering the hive-site configuration
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hive/conf/hive-site.xml.template > /usr/local/hive/conf/hive-site.xml
sed s/HOSTNAME/$HOSTNAME/ /opt/files/hive-site.xml.template > /opt/files/hive-site.xml

# start hive metastore server
$HIVE_HOME/bin/hive --service metastore &

sleep 20

# start hive server
$HIVE_HOME/bin/hive --service hiveserver2 &


if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

#if [[ $1 == "-d" ]]; then
#  while true; do sleep 1000;echo $PATH; done
#fi
