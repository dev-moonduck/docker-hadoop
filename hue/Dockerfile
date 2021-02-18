# FROM gethue/hue:4.9.0
FROM docker-hadoop-hive:1.0.0

COPY --from=gethue/hue:4.9.0 /usr/share/hue /usr/share/hue

ADD hue.ini /usr/share/hue/desktop/conf/hue.ini

COPY --chown=hue:hue start_hue.sh /start_hue.sh
RUN chmod a+x /start_hue.sh

ENTRYPOINT ["/start_hue.sh"]

CMD /usr/share/hue/startup.sh
