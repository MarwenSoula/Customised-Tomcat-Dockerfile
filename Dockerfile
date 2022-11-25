FROM ubuntu:18.04

MAINTAINER Carlos Moro <cmoro@deusto.es>

ENV TOMCAT_VERSION 9.0.69

# Set locales
RUN apt-get update && \
apt-get install -y locales && \
locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common unzip zip

# Install OpenJDK 12
RUN \
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update && \
apt-get install -y openjdk-11-jdk wget unzip tar && \
rm -rf /var/lib/apt/lists/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

# Get Tomcat
RUN wget --quiet --no-cookies https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.69/bin/apache-tomcat-9.0.69.zip -O /tmp/tomcat.zip && \
unzip /tmp/tomcat -d /opt && \
mv /opt/apache-tomcat* /opt/tomcat && \
rm /tmp/tomcat* && \
rm -rf /opt/tomcat/webapps/examples && \
rm -rf /opt/tomcat/webapps/docs && \
rm -rf /opt/tomcat/webapps/ROOT && \
chmod +x /opt/tomcat/bin/catalina.sh

# copy artifact
COPY target/javulna*.war  /opt/tomcat/webapps/

# Add admin/admin user

ADD tomcat-users.xml /opt/tomcat/conf/
ADD context.xml  /opt/tomcat/webapps/manager/META-INF
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
