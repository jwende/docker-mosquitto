FROM ubuntu:latest

MAINTAINER Joerg Wende <jwende@gmx.de>

# origin: Thomas Kerpe
# update based on Ansgar Schmidt

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev uuid-dev -y
#RUN mkdir -p /usr/local/src
#WORKDIR /usr/local/src
#RUN wget http://mosquitto.org/files/source/mosquitto-1.4.5.tar.gz
#RUN tar xvzf ./mosquitto-1.4.5.tar.gz
#WORKDIR /usr/local/src/mosquitto-1.4.5
#RUN make
#RUN make install
RUN apt-get install python-software-properties -y
RUN apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
RUN apt-get update

RUN adduser --system --disabled-password --disabled-login mosquitto

COPY config /mqtt/config
# RUN mkdir /mqtt/data 
# && chown mosquitto:mosquitto /mqtt/data
# RUN mkdir /mqtt/log 
# && chown mosquitto:mosquitto /mqtt/log
# VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]


EXPOSE 1883 9001
CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf
