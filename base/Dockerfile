FROM debian:9

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

# TODO: Bump up Java version(java 11 supported since Hadoop 3.3.0)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \
    && rm -rf /var/lib/apt/lists/*
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

RUN gpg --import KEYS

ENV HADOOP_VERSION 3.3.0
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

# hadoop groups
ARG HADOOP_GID=300
ARG HADOOP_GROUP=hadoop

# for hdfs user
ARG HADOOP_ADMIN_GID=301
ARG HADOOP_ADMIN_GROUP=hadoop-admins

# airflow, hue, hive, spark, ...
ARG HADOOP_SVC_GID=302
ARG HADOOP_SVC_GROUP=hadoop-svcs

# normal user
ARG HADOOP_USER_GID=303
ARG HADOOP_USER_GROUP=hadoop-users

# proxy user
ARG HADOOP_USER_SVC_GID=304
ARG HADOOP_USER_SVC_GROUP=hadoop-user-svcs

RUN groupadd --gid $HADOOP_GID $HADOOP_GROUP
RUN groupadd --gid $HADOOP_ADMIN_GID $HADOOP_ADMIN_GROUP
RUN groupadd --gid $HADOOP_SVC_GID $HADOOP_SVC_GROUP
RUN groupadd --gid $HADOOP_USER_GID $HADOOP_USER_GROUP
RUN groupadd --gid $HADOOP_USER_SVC_GID $HADOOP_USER_SVC_GROUP

# Admin user / no proxy user / no hadoop user / root privilege in cluster machines
ARG CLUSTER_ADMIN_USER=cluster-admin
ARG CLUSTER_ADMIN_PASSWORD=cluster-admin
ARG CLUSTER_ADMIN_UID=310
RUN useradd --uid $CLUSTER_ADMIN_UID --no-log-init --gid 0 --shell /bin/bash -p $CLUSTER_ADMIN_PASSWORD $CLUSTER_ADMIN_USER

# Normal hadoop user / no proxy user / limited privilege in hdfs
# FYI dash(-) is NOT allowed in user name
ARG DEV_USER=dev_user
ARG DEV_USER_PASSWORD=dev_user
ARG DEV_USER_UID=401
ARG DEV_USER_GROUP=$HADOOP_USER_GROUP
## Prefix HADOOP_USER will be added in hdfs user list
ENV HADOOP_USER_NAME_DEV_USER=$DEV_USER
RUN useradd --uid $DEV_USER_UID --no-log-init --groups $DEV_USER_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $DEV_USER_PASSWORD $DEV_USER

# Normal hadoop user / no proxy user / limited privilege in hdfs
ARG BI_USER=bi_user
ARG BI_USER_PASSWORD=bi_user
ARG BI_USER_UID=402
ARG BI_USER_GROUP=$HADOOP_USER_GROUP
## Prefix HADOOP_USER will be added in hdfs user list
ENV HADOOP_USER_NAME_BI_USER=$BI_USER
RUN useradd --uid $BI_USER_UID --no-log-init --groups $BI_USER_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $BI_USER_PASSWORD $BI_USER

# Normal hadoop user / no proxy user / limited privilege in hdfs
ARG ML_USER=ml_user
ARG ML_USER_PASSWORD=ml_user
ARG ML_USER_UID=403
ARG ML_USER_GROUP=$HADOOP_USER_GROUP
## Prefix HADOOP_USER will be added in hdfs user list
ENV HADOOP_USER_NAME_$ML_USER=$ML_USER
RUN useradd --uid $ML_USER_UID --no-log-init --groups $ML_USER_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $ML_USER_PASSWORD $ML_USER

# hdfs super user / no login
ARG HDFS_USER=hdfs
ARG HDFS_UID=320
ARG HDFS_USER_PASSWORD=hdfs
ARG HDFS_GROUP=$HADOOP_ADMIN_GROUP
ENV HADOOP_USER_NAME_$HDFS_USER=$HDFS_USER
RUN useradd --uid $HDFS_UID --no-log-init --groups $HDFS_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $HDFS_USER_PASSWORD $HDFS_USER

# webhdfs super user / no login
ARG WEBHDFS_USER=webhdfs
ARG WEBHDFS_UID=321
ARG WEBHDFS_USER_PASSWORD=webhdfs
ARG WEBHDFS_GROUP=$HADOOP_ADMIN_GROUP
ENV HADOOP_USER_NAME_$WEBHDFS_USER=$WEBHDFS_USER
RUN useradd --uid $WEBHDFS_UID --no-log-init --groups $WEBHDFS_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $WEBHDFS_USER_PASSWORD $WEBHDFS_USER

# hadoop service user / proxy user
ARG HIVE_USER=hive
ARG HIVE_UID=330
ARG HIVE_USER_PASSWORD=hive
ARG HIVE_GROUP=$HADOOP_SVC_GROUP
ENV HADOOP_USER_NAME_$HIVE_USER=$HIVE_USER
# proxy.hosts/groups are * by default. but explicitly set it as * is not allowed because * and @ is special meaning in bash
# TODO: Make it work with *(asterisk) as value
ENV HADOOP_USER_OPT_$HIVE_USER="proxy.user=true"
RUN useradd --uid $HIVE_UID --no-log-init --groups $HIVE_GROUP --shell /bin/false --create-home -p $HIVE_USER_PASSWORD $HIVE_USER

ARG PRESTO_USER=presto
ARG PRESTO_UID=340
ARG PRESTO_USER_PASSWORD=presto
ARG PRESTO_GROUP=$HADOOP_SVC_GROUP
ENV HADOOP_USER_NAME_PRESTO=$PRESTO_USER
ENV HADOOP_USER_OPT_$PRESTO_USER="proxy.user=true"
RUN useradd --uid $PRESTO_UID --no-log-init --groups $PRESTO_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $PRESTO_USER_PASSWORD $PRESTO_USER

ARG KAFKA_USER=kafka
ARG KAFKA_UID=350
ARG KAFKA_USER_PASSWORD=kafka
ARG KAFKA_GROUP=$HADOOP_SVC_GROUP
ENV HADOOP_USER_NAME_$KAFKA_USER=$KAFKA_USER
ENV HADOOP_USER_OPT_$KAFKA_USER="proxy.user=true"
RUN useradd --uid $KAFKA_UID --no-log-init --groups $KAFKA_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $KAFKA_USER_PASSWORD $KAFKA_USER

ARG HUE_USER=hue
ARG HUE_UID=360
ARG HUE_USER_PASSWORD=hue
ARG HUE_GROUP=$HADOOP_SVC_GROUP
ENV HADOOP_USER_NAME_$HUE_USER=$HUE_USER
ENV HADOOP_USER_OPT_$HUE_USER="proxy.user=true"
RUN useradd --uid $HUE_UID --no-log-init --groups $HUE_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $HUE_USER_PASSWORD $HUE_USER

ARG AIRFLOW_USER=airflow
ARG AIRFLOW_UID=370
ARG AIRFLOW_USER_PASSWORD=airflow
ARG AIRFLOW_GROUP=$HADOOP_SVC_GROUP
ENV HADOOP_USER_NAME_$AIRFLOW_USER=$AIRFLOW_USER
ENV HADOOP_USER_OPT_$AIRFLOW_USER="proxy.user=true"
RUN useradd --uid $AIRFLOW_UID --no-log-init --groups $AIRFLOW_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $AIRFLOW_USER_PASSWORD $AIRFLOW_USER

ARG SPARK_USER=spark
ARG SPARK_UID=380
ARG SPARK_USER_PASSWORD=spark
ARG SPARK_GROUP=$HADOOP_SVC_GROUP
ENV HADOOP_USER_NAME_$SPARK_USER=$SPARK_USER
ENV HADOOP_USER_OPT_$SPARK_USER="proxy.user=true"
RUN useradd --uid $SPARK_UID --no-log-init --groups $SPARK_GROUP --shell /usr/sbin/nologin --no-create-home --system -p $SPARK_USER_PASSWORD $SPARK_USER

# user service user / proxy user
ARG SVC_USER=svc
ARG SVC_UID=500
ARG SVC_USER_PASSWORD=svc
ARG SVC_GROUP=$HADOOP_USER_SVC_GROUP
ENV HADOOP_USER_NAME_$SVC_USER=$SVC_USER
ENV HADOOP_USER_OPT_$SVC_USER="proxy.user=true"
RUN useradd --uid $SVC_UID --no-log-init --groups $SVC_GROUP --shell /usr/sbin/nologin --no-create-home -p $SVC_PASSWORD --system $SVC_USER

# Scripts to run before/after entrypoint, extra config script in /config
RUN mkdir -p /prerun
RUN mkdir -p /postrun
RUN mkdir -p /config

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=$CLUSTER_ADMIN_USER
ENV PATH $HADOOP_HOME/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
ADD functions.sh /functions.sh

RUN chmod a+x /entrypoint.sh && chmod a+x /functions.sh

ENTRYPOINT ["/entrypoint.sh"]
