FROM docker-hadoop-base:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name 
VOLUME /hadoop/dfs/name

EXPOSE 9870

CMD ["/postrun/000_run.sh"]
