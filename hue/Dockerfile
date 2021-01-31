FROM gethue/hue:20210122-162227

COPY --from=docker-hadoop-hive:1.0.0 /etc/hadoop /etc/hadoop
COPY --from=docker-hadoop-hive:1.0.0 /etc/hive /etc/hive

ADD hue.ini /usr/share/hue/desktop/conf/hue.ini

CMD /usr/share/hue/startup.sh
