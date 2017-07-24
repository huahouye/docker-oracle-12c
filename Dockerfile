FROM centos:centos7

MAINTAINER huahouye <huahouye@gmail.com>

ENV ORACLE_HOME /ora01/app/oracle/product/12.2.0/db_1
ENV ORACLE_SID  ORA12C

ADD tmp/database /tmp/database
ADD config /config/

RUN whoami && chmod +x /config/*.sh && ls -l /config/ && sh /config/install-part1.sh

USER oracle
RUN whoami && sh /config/install-part2.sh

USER root
RUN whoami && sh /config/install-part3.sh

USER oracle
RUN whoami && sh /config/install-part4.sh

CMD ["/config/start.sh"] 

EXPOSE 1521 5500 8080