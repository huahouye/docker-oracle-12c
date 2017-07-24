#!/bin/sh

# install oracle 12c release 2 part 2, logon as oracle

set -x

## Start binaries installation (run as oracle)
### wait for several minutes
./tmp/database/runInstaller -silent -responseFile /tmp/database/response/db_install.rsp