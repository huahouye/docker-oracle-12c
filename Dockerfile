FROM centos:centos7
MAINTAINER huahouye <huahouye@gmail.com>
ADD tmp/database /tmp/
ADD config /config/
RUN chmod +x /config/*.sh && chmod 755 /config/*.sh && /bin/sh -c /config/install-oracle.sh
CMD ["/bin/sh", "-c", "/config/start.sh"] 

EXPOSE 1521 5500 8080