FROM docker-hadoop-base:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

RUN mkdir -p /hadoop/dfs/name && mkdir -p /hadoop/yarn/timeline && mkdir -p /tmp/spark-events
VOLUME /hadoop/dfs/name

EXPOSE 9870

CMD ["/bin/bash"]
