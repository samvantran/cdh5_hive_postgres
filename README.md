# Cloudera Hadoop (YARN, HDFS, Hive) Docker image


This is a Hadoop Docker image running CDH5 versions of YARN, HDFS, and Hive, all in one container. Adapted from https://github.com/tilakpatidar/cdh5_hive_postgres and based on Ubuntu (trusty).

## Current Version
* Hadoop 2.6.0

## Build the image
Download dependencies:
```
./download_deps.sh
```

Build the Ubuntu base image:
```
cd ubuntu
docker build -t cdh5-ubuntu .
```

Build the Hadoop image:
```
cd ../hadoop-2.6.0
docker build -t cdh5-hadoop .
```

Build the Hive image:
```
cd ../hive_pg
docker build -t cdh5-hive .
```

Build the Kerberized Hive image:
```
cd ../kerberos
docker build -t cdh5-hive-kerberos .
```
