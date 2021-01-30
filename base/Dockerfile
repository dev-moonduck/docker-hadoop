FROM debian:9

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

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

ENV HADOOP_VERSION 3.2.1
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
ARG DEV_USER=dev-user
ARG DEV_USER_PASSWORD=dev-user
ARG DEV_USER_UID=401
## Prefix HADOOP_USER will be added in hdfs user list
ENV HADOOP_USER_NAME_DEV_USER=$DEV_USER
ENV HADOOP_USER_GROUP_DEV=$HADOOP_USER_GROUP
RUN useradd --uid $DEV_USER_UID --no-log-init --groups $HADOOP_USER_GROUP_DEV --shell /usr/sbin/nologin --no-create-home --system -p $DEV_USER_PASSWORD $DEV_USER

# Normal hadoop user / no proxy user / limited privilege in hdfs
ARG BI_USER=bi-user
ARG BI_USER_PASSWORD=bi-user
ARG BI_USER_UID=402
## Prefix HADOOP_USER will be added in hdfs user list
ENV HADOOP_USER_NAME_BI_USER=$BI_USER
ENV HADOOP_USER_GROUP_BI_USER=$HADOOP_USER_GROUP
RUN useradd --uid $BI_USER_UID --no-log-init --groups $HADOOP_USER_GROUP_BI_USER --shell /usr/sbin/nologin --no-create-home --system -p $BI_USER_PASSWORD $BI_USER

# Normal hadoop user / no proxy user / limited privilege in hdfs
ARG ML_USER=ml-user
ARG ML_USER_PASSWORD=ml-user
ARG ML_USER_UID=403
## Prefix HADOOP_USER will be added in hdfs user list
ENV HADOOP_USER_NAME_ML_USER=$ML_USER
ENV HADOOP_USER_GROUP_ML_USER=$HADOOP_USER_GROUP
RUN useradd --uid $ML_USER_UID --no-log-init --groups $HADOOP_USER_GROUP_ML_USER --shell /usr/sbin/nologin --no-create-home --system -p $ML_USER_PASSWORD $ML_USER

# hdfs super user / no login
ARG HDFS_UID=320
ENV HADOOP_USER_NAME_HDFS=hdfs
ENV HADOOP_USER_GROUP_HDFS=$HADOOP_ADMIN_GROUP
RUN useradd --uid $HDFS_UID --no-log-init --groups $HADOOP_USER_GROUP_HDFS --shell /usr/sbin/nologin --no-create-home --system hdfs

# hadoop service user / proxy user
ARG HIVE_USER=hive
ARG HIVE_UID=340
ENV HADOOP_USER_NAME_HIVE=$HIVE_USER
ENV HADOOP_USER_GROUP_HIVE=$HADOOP_SVC_GROUP
RUN useradd --uid $HIVE_UID --no-log-init --groups $HADOOP_USER_GROUP_HIVE --shell /usr/sbin/nologin --no-create-home --system $HIVE_USER

ARG PRESTO_USER=presto
ARG PRESTO_UID=350
ENV HADOOP_USER_NAME_PRESTO=$PRESTO_USER
ENV HADOOP_USER_GROUP_PRESTO=$HADOOP_SVC_GROUP
RUN useradd --uid $PRESTO_UID --no-log-init --groups $HADOOP_USER_GROUP_PRESTO --shell /usr/sbin/nologin --no-create-home --system $PRESTO_USER

ARG KAFKA_USER=kafka
ARG KAFKA_UID=360
ENV HADOOP_USER_NAME_KAFKA=$KAFKA_USER
ENV HADOOP_USER_GROUP_KAFKA=$HADOOP_SVC_GROUP
RUN useradd --uid $KAFKA_UID --no-log-init --groups $HADOOP_USER_GROUP_KAFKA --shell /usr/sbin/nologin --no-create-home --system $KAFKA_USER

ARG HUE_USER=hue
ARG HUE_UID=370
ENV HADOOP_USER_NAME_HUE=$HUE_USER
ENV HADOOP_USER_GROUP_HUE=$HADOOP_SVC_GROUP
RUN useradd --uid $HUE_UID --no-log-init --groups $HADOOP_USER_GROUP_HUE --shell /usr/sbin/nologin --no-create-home --system $HUE_USER

ARG AIRFLOW_USER=airflow
ARG AIRFLOW_UID=380
ENV HADOOP_USER_NAME_AIRFLOW=$AIRFLOW_USER
ENV HADOOP_USER_GROUP_AIRFLOW=$HADOOP_SVC_GROUP
RUN useradd --uid $AIRFLOW_UID --no-log-init --groups $HADOOP_USER_GROUP_AIRFLOW --shell /usr/sbin/nologin --no-create-home --system $AIRFLOW_USER

ARG SPARK_USER=spark
ARG SPARK_UID=390
ENV HADOOP_USER_NAME_SPARK=$SPARK_USER
ENV HADOOP_USER_GROUP_SPARK=$HADOOP_SVC_GROUP
RUN useradd --uid $SPARK_UID --no-log-init --groups $HADOOP_USER_GROUP_SPARK --shell /usr/sbin/nologin --no-create-home --system $SPARK_USER

# user service user / proxy user
ARG SVC_USER=svc
ARG SVC_UID=330
ENV HADOOP_USER_NAME_SVC=$SVC_USER
ENV HADOOP_USER_GROUP_SVC=$HADOOP_USER_SVC_GROUP
RUN useradd --uid $SVC_UID --no-log-init --groups $HADOOP_USER_GROUP_SVC --shell /usr/sbin/nologin --no-create-home --system $SVC_USER

# Scripts to run before/after entrypoint
RUN mkdir -p /prerun && mkdir -p /postrun

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=$CLUSTER_ADMIN_USER
ENV PATH $HADOOP_HOME/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
