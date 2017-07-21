#!/bin/sh

# install oracle 12c release 2

# http://dbaora.com/install-oracle-in-silent-mode-12c-release-2-12-2-on-oel7/

set -x

echo "127.0.0.1 oel7 oel7.dbaora.com localhost.localdomain localhost" >> /etc/hosts
hostnamectl set-hostname oel7.dbaora.com --static

groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
groupadd -g 54324 backupdba
groupadd -g 54325 dgdba
groupadd -g 54326 kmdba
groupadd -g 54327 asmdba
groupadd -g 54328 asmoper
groupadd -g 54329 asmadmin
groupadd -g 54330 racdba

useradd -u 54321 -g oinstall -G dba,oper,backupdba,dgdba,kmdba,racdba oracle

yum install -y binutils.x86_64 compat-libcap1.x86_64 gcc.x86_64 gcc-c++.x86_64 glibc.i686 glibc.x86_64 \
glibc-devel.i686 glibc-devel.x86_64 ksh compat-libstdc++-33 libaio.i686 libaio.x86_64 libaio-devel.i686 libaio-devel.x86_64 \
libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++-devel.i686 libstdc++-devel.x86_64 libXi.i686 libXi.x86_64 \
libXtst.i686 libXtst.x86_64 make.x86_64 sysstat.x86_64
##### yum clean all

cat << EOF >> /etc/sysctl.conf
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
kernel.panic_on_oops=1
EOF

/sbin/sysctl -p

cat << EOF >> /etc/security/limits.conf
oracle   soft   nofile   1024
oracle   hard   nofile   65536
oracle   soft   nproc    2047
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32768
oracle   soft   memlock  3145728
oracle   hard   memlock  3145728
EOF

systemctl stop firewalld
systemctl disable firewalld

cat << \EOF >> /home/oracle/.bash_profile
export TMP=/tmp

export ORACLE_HOSTNAME=oel7.dbaora.com
export ORACLE_UNQNAME=ORA12C
export ORACLE_BASE=/ora01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.2.0/db_1
export ORACLE_SID=ORA12C

PATH=/usr/sbin:$PATH:$ORACLE_HOME/bin

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib;
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib;

export PATH

alias cdob='cd $ORACLE_BASE'
alias cdoh='cd $ORACLE_HOME'
alias tns='cd $ORACLE_HOME/network/admin'
alias envo='env | grep ORACLE'

umask 022

if [ $USER = "oracle" ]; then
    if [ $SHELL = "/bin/ksh" ]; then
       ulimit -u 16384 
       ulimit -n 65536
    else
       ulimit -u 16384 -n 65536
    fi
fi

envo
EOF

mkdir -p /ora01/app/oracle/product/12.2.0/db_1
chown oracle:oinstall -R /ora01

## systemctl mask tmp.mount
chown oracle:oinstall -R /tmp/database

# edit oracle rsp files
cat << \EOF > /tmp/database/response/db_install.rsp
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v12.2.0
oracle.install.option=INSTALL_DB_SWONLY
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/ora01/app/oraInventory
ORACLE_HOME=/ora01/app/oracle/product/12.2.0/db_1
ORACLE_BASE=/ora01/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=dba
oracle.install.db.OSOPER_GROUP=oper
oracle.install.db.OSBACKUPDBA_GROUP=backupdba
oracle.install.db.OSDGDBA_GROUP=dgdba
oracle.install.db.OSKMDBA_GROUP=kmdba
oracle.install.db.OSRACDBA_GROUP=racdba
oracle.install.db.rac.configurationType=
oracle.install.db.CLUSTER_NODES=
oracle.install.db.isRACOneInstall=
oracle.install.db.racOneServiceName=
oracle.install.db.rac.serverpoolName=
oracle.install.db.rac.serverpoolCardinality=
oracle.install.db.config.starterdb.type=
oracle.install.db.config.starterdb.globalDBName=
oracle.install.db.config.starterdb.SID=
oracle.install.db.ConfigureAsContainerDB=
oracle.install.db.config.PDBName=
oracle.install.db.config.starterdb.characterSet=
oracle.install.db.config.starterdb.memoryOption=
oracle.install.db.config.starterdb.memoryLimit=
oracle.install.db.config.starterdb.installExampleSchemas=
oracle.install.db.config.starterdb.password.ALL=
oracle.install.db.config.starterdb.password.SYS=
oracle.install.db.config.starterdb.password.SYSTEM=
oracle.install.db.config.starterdb.password.DBSNMP=
oracle.install.db.config.starterdb.password.PDBADMIN=
oracle.install.db.config.starterdb.managementOption=
oracle.install.db.config.starterdb.omsHost=
oracle.install.db.config.starterdb.omsPort=
oracle.install.db.config.starterdb.emAdminUser=
oracle.install.db.config.starterdb.emAdminPassword=
oracle.install.db.config.starterdb.enableRecovery=
oracle.install.db.config.starterdb.storageType=
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=
oracle.install.db.config.asm.diskGroup=
oracle.install.db.config.asm.ASMSNMPPassword=
MYORACLESUPPORT_USERNAME=
MYORACLESUPPORT_PASSWORD=
SECURITY_UPDATES_VIA_MYORACLESUPPORT=
DECLINE_SECURITY_UPDATES=
PROXY_HOST=
PROXY_PORT=
PROXY_USER=
PROXY_PWD=
COLLECTOR_SUPPORTHUB_URL=
EOF

cat << \EOF > /tmp/database/response/dbca.rsp
gdbName=ORA12C.dbaora.com
sid=ORA12C
createAsContainerDatabase=true
numberOfPDBs=1
pdbName=PORA12C1
pdbAdminPassword=Oracle12c
templateName=General_Purpose.dbc
sysPassword=Oracle12c
systemPassword=Oracle12c
emConfiguration=DBEXPRESS
emExpressPort=5500
dbsnmpPassword=Oracle12c
datafileDestination=/ora01/app/oracle/oradata
recoveryAreaDestination=/ora01/app/oracle/flash_recovery_area
storageType=FS
characterSet=AL32UTF8
nationalCharacterSet=AL16UTF16
listeners=LISTENER
sampleSchema=true
databaseType=OLTP
automaticMemoryManagement=TRUE
totalMemory=400
EOF

## Start binaries installation (run as oracle)
su - oracle -c "cd /tmp/database; ./runInstaller -silent -responseFile /tmp/database/response/db_install.rsp"

/ora01/app/oraInventory/orainstRoot.sh
/ora01/app/oracle/product/12.2.0/db_1/root.sh

## run database installation (run as oracle)
su - oracle -c "cd /tmp/database; dbca -silent -createDatabase -responseFile /tmp/database/response/dbca.rsp"








