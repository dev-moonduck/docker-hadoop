FROM docker-hadoop-base:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

ENV ZOOKEEPER_HOME=/opt/zookeeper

COPY --from=zookeeper:3.6.2 /apache-zookeeper-3.6.2-bin /opt/zookeeper

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data && mkdir -p /opt/zookeeper/data
VOLUME /hadoop/dfs/data

EXPOSE 9864

CMD ["/bin/bash"]
