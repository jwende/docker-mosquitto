FROM ubuntu:latest

MAINTAINER Joerg Wende <jwende@gmx.de>

# origin: Thomas Kerpe
# update based on Ansgar Schmidt

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev uuid-dev -y
RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src

#WebSockets https://goochgooch.wordpress.com/2014/08/01/building-mosquitto-1-4/
RUN apt-get install cmake -y
RUN wget http://git.warmcat.com/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.5-chrome47-firefox41.tar.gz  
RUN tar -xzvf libwebsockets-1.5-chrome47-firefox41.tar.gz  
RUN cd libwebsockets-1.5-chrome47-firefox41
RUN mkdir build
RUN cd build
WORKDIR /usr/local/src/libwebsockets-1.5-chrome47-firefox41/build
RUN cmake .. 
RUN make
RUN make install
RUN ldconfig

#Mosquitto
RUN cd /usr/local/src
WORKDIR /usr/local/src
RUN wget http://mosquitto.org/files/source/mosquitto-1.4.5.tar.gz
RUN tar xvzf ./mosquitto-1.4.5.tar.gz
RUN cd /usr/local/src/mosquitto-1.4.5
WORKDIR /usr/local/src/mosquitto-1.4.5
COPY make/config.mk /usr/local/src/mosquitto-1.4.5/config.mk
RUN make
RUN make install

# config
WORKDIR /home
RUN adduser --system --disabled-password --disabled-login mosquitto 
RUN mkdir /mqtt
COPY config /mqtt/config
RUN mkdir /mqtt/data
RUN mkdir /mqtt/log
RUN chown -hR mosquitto /mqtt 
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]


EXPOSE 1883 9001
CMD mosquitto -c /mqtt/config/mosquitto.conf
