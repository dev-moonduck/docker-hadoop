FROM debian:10.7

ARG SPARK_VERSION=3.1.1
ARG SCALA_VERSION=2.13

COPY --from=openjdk:8-jdk-slim /usr/local/openjdk-8 /usr/local/openjdk-8
RUN export JAVA_HOME=/usr/local/openjdk-8
RUN echo "deb http://ftp.us.debian.org/debian sid main" >> /etc/apt/sources.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      git \
      curl \
      openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /target && git clone https://github.com/apache/spark.git && \
 cd spark && git checkout v$SPARK_VERSION \
 && ./dev/change-scala-version.sh $SCALA_VERSION \
 && ./dev/make-distribution.sh --name spark --tgz -Phive -Phive-thriftserver -Pyarn -Pscala-2.13 -DskipTests -Phadoop-provided -Dhadoop.version=3.3.0 \
 && mv spark.tgz /target && rm -rf /spark
