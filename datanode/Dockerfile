FROM docker-hadoop-base:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

# ADD run.sh /postrun/run.sh
# RUN chmod a+x /postrun/run.sh

EXPOSE 9864

CMD ["/postrun/run.sh"]
