FROM centos:centos7

MAINTAINER huahouye <huahouye@gmail.com>

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

EXPOSE 1521
EXPOSE 8080

ADD tmp/database /tmp/
ADD config /config/
ADD install/ /
RUN chmod +x /*.sh && chmod 755 /*.sh  \
	&& sh -c /install.sh

# Run script
ADD config/start.sh /
RUN chmod +x /start.sh && chmod 755 /start.sh
CMD ["/bin/sh", "-c", "/start.sh"] 
