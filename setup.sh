#!/bin/bash

if [ ! -d "opengrok-1.3.16" ]; then
	wget https://github.com/oracle/opengrok/releases/download/1.3.16/opengrok-1.3.16.tar.gz
	tar xvzf opengrok-1.3.16.tar.gz
fi

if [ ! -d "apache-tomcat-8.5.57" ]; then
	wget https://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.57/bin/apache-tomcat-8.5.57.tar.gz
	tar xvzf apache-tomcat-8.5.57.tar.gz
fi

if [ ! -f "source.war" ]; then
	cp opengrok-1.3.16/lib/source.war .
fi

if [ ! -d "apache-tomcat-8.5.57/webapps/$1" ]; then
	unzip source.war -d apache-tomcat-8.5.57/webapps/$1
fi

./apache-tomcat-8.5.57/bin/startup.sh

mkdir -p opengrok/projects
mkdir -p opengrok/etc
mkdir -p opengrok/projects/$1

java -Djava.util.logging.config.file=opengrok/logging.properties -jar opengrok-1.3.16/lib/opengrok.jar -s $2 -d opengrok/projects/$1 -H -P -S -G -W opengrok/etc/configuration.xml -U http://localhost:8080/$1 $3
