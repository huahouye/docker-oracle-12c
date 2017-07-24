#!/bin/sh

# install oracle 12c release 2 part 4, logon as oracle

set -x

## Configure Oracle Net
### 端口 1521 被占用，实际没有 http://blog.csdn.net/xiangsir/article/details/8632048
### less /ora01/app/oracle/cfgtoollogs/netca/trace_OraDB12Home1-1707215PM0219.log
netca -silent -responseFile /tmp/database/response/netca.rsp

## run database installation (run as oracle)
lsnrctl start && lsnrctl status && mkdir /ora01/app/oracle/oradata && mkdir /ora01/app/oracle/flash_recovery_area
### less /ora01/app/oracle/cfgtoollogs/dbca/ORA12C/ORA12C0.log
dbca -silent -createDatabase -responseFile /tmp/database/response/dbca.rsp

## vi /etc/oratab
echo "ORA12C:$ORACLE_HOME:Y" > /etc/oratab

## vi $ORACLE_HOME/network/admin/sqlnet.ora append a new option
echo "SQLNET.ALLOWED_LOGON_VERSION=8" >> $ORACLE_HOME/network/admin/sqlnet.ora
