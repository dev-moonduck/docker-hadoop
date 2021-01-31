FROM docker-hadoop-base:1.0.0

COPY --from=docker-hadoop-hive:1.0.0 /etc/hadoop /etc/hadoop
COPY --from=docker-hadoop-hive:1.0.0 /opt/hive /opt/hive

ARG TRINO_VERSION="351"

# TODO: Replace LINK to Mirror
# ARG PRESTO_DOWNLOAD_LINK="https://repo1.maven.org/maven2/com/facebook/presto/presto-server/$TRINO_VERSION/presto-server-$TRINO_VERSION.tar.gz"
# RUN curl "$PRESTO_DOWNLOAD_LINK" -o /tmp/presto.tar.gz

ENV TRINO_HOME=/opt/trino-server-$TRINO_VERSION

COPY trino-server-$TRINO_VERSION.tar.gz /tmp

RUN mkdir -p /var/log/trino-$TRINO_VERSION && mkdir -p /var/trino/data
RUN tar -xvf /tmp/trino-server-$TRINO_VERSION.tar.gz -C /opt/ && rm -f /tmp/trino-server-$TRINO_VERSION.tar.gz && mkdir -p /opt/trino-server-$TRINO_VERSION/etc
RUN ln -s /opt/trino-server-$TRINO_VERSION /etc/trino

COPY 999_run.sh /postrun/
CMD ["/postrun/999_run.sh"]

ENTRYPOINT ["/entrypoint.sh"]