#!/bin/sh

# install oracle 12c
# reference https://wiki.centos.org/HowTos/Oracle12onCentos7
# https://pierreforstmanndotcom.wordpress.com/2013/06/27/how-to-install-oracle-12-1-in-silent-mode/
# http://dbaora.com/install-oracle-in-silent-mode-11g-release-2-11-2/
# https://pierreforstmanndotcom.wordpress.com/2017/03/01/oracle-database-12-2-0-1-silent-installation-and-database-creation-on-oracle-linux-7/
# http://dbaora.com/install-oracle-in-silent-mode-12c-release-2-12-2-on-oel7/

set -x

groupadd oinstall
groupadd dba
useradd -g oinstall -G dba oracle
echo oracle | passwd oracle --stdin

cat << EOF >> /etc/sysctl.conf
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 1987162112
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586
EOF

cat << EOF >> /etc/security/limits.conf
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
EOF

mkdir /u01
mkdir /u01/db12201
mkdir /u01/orainv
mkdir /u01/oracle
chmod g+s /u01
chown -R oracle:dba /u01
mkdir /u02
mkdir /u02/db12201
mkdir /u02/orainv
mkdir /u02/oracle
chmod g+s /u02
chown -R oracle:dba /u02

chown -R oracle:oinstall /tmp/

yum install -y binutils.x86_64 compat-libcap1.x86_64 gcc.x86_64 gcc-c++.x86_64 glibc.i686 glibc.x86_64 \
glibc-devel.i686 glibc-devel.x86_64 ksh compat-libstdc++-33 libaio.i686 libaio.x86_64 libaio-devel.i686 libaio-devel.x86_64 \
libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++-devel.i686 libstdc++-devel.x86_64 libXi.i686 libXi.x86_64 \
libXtst.i686 libXtst.x86_64 make.x86_64 sysstat.x86_64
##### yum clean all

rm -rf /u01/orainv/logs
su - oracle -c "/install-su-oracle.sh"

/u01/orainv/orainstRoot.sh
/u01/db12201/root.sh
cat /u01/db12201/install/root_ol7ttfs1.localdomain_2017-03-01_21-09-04-788037704.log

export ORACLE_HOME=/u01/db12201
PATH=$ORACLE_HOME/bin:$PATH
$ORACLE_HOME/OPatch/opatch lsinv