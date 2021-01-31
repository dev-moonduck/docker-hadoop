FROM gethue/hue:20210122-162227

COPY --from=docker-hadoop-hive:1.0.0 /etc/hadoop /etc/hadoop
COPY --from=docker-hadoop-hive:1.0.0 /opt/hive/ /opt/hive
COPY --from=docker-hadoop-hive:1.0.0 /functions.sh /functions.sh

ADD hue.ini /usr/share/hue/desktop/conf/hue.ini

COPY --chown=hue:hue start_hue.sh /start_hue.sh
RUN chmod a+x /start_hue.sh

ENTRYPOINT ["/start_hue.sh"]

CMD /usr/share/hue/startup.sh
