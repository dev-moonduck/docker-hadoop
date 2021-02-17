FROM docker-hadoop-datanode:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

USER root

ARG HIVE_VERSION

ENV HIVE_VERSION=${HIVE_VERSION:-3.1.2}

ENV HIVE_HOME=/opt/hive
ENV PATH=$HIVE_HOME/bin:$PATH

WORKDIR /opt

RUN echo "deb http://ftp.us.debian.org/debian sid main" >> /etc/apt/sources.list

ENV JAVA8_HOME=/usr/local/openjdk-8
COPY --from=openjdk:8-jdk /usr/local/openjdk-8 /usr/local/openjdk-8

#Install Hive and PostgreSQL JDBC
RUN apt update && apt install -y wget procps && \
	wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	wget https://jdbc.postgresql.org/download/postgresql-42.2.18.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
	apt --purge remove -y wget && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*


#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to $SPARK_HOME/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf


EXPOSE 10000
EXPOSE 10002

# Hive uses too old guava, it causes error(https://stackoverflow.com/questions/58176627/how-can-i-ask-hive-to-provide-more-detailed-error) when schematool runs
COPY ./jars/guava-27.0-jre.jar $HIVE_HOME/lib/
RUN rm -f $HIVE_HOME/lib/guava-19.0.jar

CMD ["/bin/bash"]