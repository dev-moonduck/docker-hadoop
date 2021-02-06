FROM docker-hadoop-base:1.0.0

MAINTAINER Mun Duk Hyun <dev.moonduck@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

# ADD run.sh /run.sh
# RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/run.sh"]
