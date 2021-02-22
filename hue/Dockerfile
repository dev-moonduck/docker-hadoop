# FROM gethue/hue:4.9.0

# COPY --from=docker-hadoop-hive:1.0.0 /etc/hadoop /etc/hadoop
# COPY --from=docker-hadoop-hive:1.0.0 /opt/ /opt/
# COPY --from=docker-hadoop-hive:1.0.0 /scripts/ /scripts/

FROM docker-hadoop-hive:1.0.0

COPY --from=gethue/hue:4.9.0 /usr/share/hue /usr/share/hue

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      
    && rm -rf /var/lib/apt/lists/*

ADD hue.ini /usr/share/hue/desktop/conf/hue.ini

