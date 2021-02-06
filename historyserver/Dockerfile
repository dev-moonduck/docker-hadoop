FROM docker-hadoop-base:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:8188/ || exit 1

ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
RUN mkdir -p /hadoop/yarn/timeline && mkdir -p /tmp/spark-events
VOLUME /hadoop/yarn/timeline

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      procps \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8188

CMD ["/run.sh"]
