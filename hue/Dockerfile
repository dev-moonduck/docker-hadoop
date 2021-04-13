FROM docker-hadoop-hive:1.0.0

COPY --from=gethue/hue:4.9.0 /usr/share/hue /usr/share/hue
COPY --from=gethue/hue:4.9.0 /usr/bin/python3.6 /usr/bin/python3.6-config /usr/bin/python3.6m /usr/bin/python3.6m-config /usr/bin/
COPY --from=gethue/hue:4.9.0 /usr/lib/python3.6 /usr/lib/python3.6
COPY --from=gethue/hue:4.9.0 /usr/lib/python3/dist-packages /usr/lib/python3/dist-packages

ADD hue.ini /usr/share/hue/desktop/conf/hue.ini
