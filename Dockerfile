FROM ubuntu:latest

MAINTAINER Joerg Wende <jwende@gmx.de>

# origin: Thomas Kerpe


RUN apt-get update && apt-get install -y wget

RUN wget -q -O - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -
RUN wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list http://repo.mosquitto.org/debian/mosquitto-jessie.list
RUN apt-get update && apt-get install -y mosquitto

RUN adduser --system --disabled-password --disabled-login mosquitto

COPY config /mqtt/config
RUN mkdir /mqtt/data && chown mosquitto:mosquitto /mqtt/data
RUN mkdir /mqtt/log && chown mosquitto:mosquitto /mqtt/log
# VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]


EXPOSE 1883 9001
CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf
