FROM gliderlabs/alpine:3.2

MAINTAINER Julien Paoletti <julien.paoletti@gmail.com>

EXPOSE 3306

RUN apk-install mysql mysql-client

VOLUME ["/var/lib/mysql", "/etc/mysql/conf.d/"]
