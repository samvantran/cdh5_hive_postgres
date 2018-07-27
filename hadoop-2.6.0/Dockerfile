# Creates pseudo distributed hadoop 2.6.0 in ubuntu
FROM susanxhuynh/cdh5-ubuntu

USER root

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV HIVE_HOME /usr/local/hive
ENV HIVE_CONF /usr/local/hive/conf
ENV HIVE_VERSION 1.1.0
ENV HADOOP_VERSION 2.6.0
ENV CDH_VERSION 5
ENV CDH_EXACT_VERSION 5.11.0
ENV POSTGRESQL_MAIN /var/lib/postgresql/9.5/main/
ENV POSTGRESQL_CONFIG_FILE /var/lib/postgresql/9.5/main/postgresql.conf
ENV POSTGRESQL_BIN /usr/lib/postgresql/9.5/bin/postgres
ENV PGPASSWORD hive
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop

ENV PATH $PATH:$JAVA_HOME/bin:$HIVE_HOME/bin:$HADOOP_HOME:$HADOOP_HOME/bin

ADD ./deps/hadoop-${HADOOP_VERSION}-cdh${CDH_EXACT_VERSION}.tar.gz /usr/local
RUN cd /usr/local && ln -s ./hadoop-${HADOOP_VERSION}-cdh${CDH_EXACT_VERSION} hadoop

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# copy hadoop site xml files
RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

# pseudo distributed configurations
ADD templates/core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

# format namenode
RUN $HADOOP_PREFIX/bin/hdfs namenode -format

# fixing the libhadoop.so
RUN rm -rf /usr/local/hadoop/lib/native/*
ADD ./deps/hadoop-native-64-2.6.0.tar /usr/local/hadoop/lib/native/

# add and set permissions for bootstrap script
ADD scripts/bootstrap.sh /etc/hadoop-bootstrap.sh
RUN chown root:root /etc/hadoop-bootstrap.sh
RUN chmod 700 /etc/hadoop-bootstrap.sh

RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh

# run bootstrap script
ENTRYPOINT ["/etc/hadoop-bootstrap.sh", "-bash"]

#for exposed ports refer
#https://www.cloudera.com/documentation/enterprise/5-4-x/topics/cdh_ig_ports_cdh5.html

EXPOSE 50010 50020 50070 50075 50090 8020 9000 10020 19888 8030 8031 8032 8033 8040 8042 8088