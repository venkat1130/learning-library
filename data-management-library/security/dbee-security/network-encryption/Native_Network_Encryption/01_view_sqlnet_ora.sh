#!/bin/bash


# keep track of script usage with a simple curl query
# the remote host runs nginx and uses a javascript function to mask your public ip address
# see here for details: https://www.nginx.com/blog/data-masking-user-privacy-nginscript/
#
file_path=`realpath "$0"`
curl -Is --connect-timeout 3 http://150.136.21.99:6868${file_path} > /dev/null

echo
echo "The contents of the sqlnet.ora are:"
echo
cat ${ORACLE_HOME}/network/admin/sqlnet.ora

HAS_WALLET_ENTRY=`grep ENCRYPTION_WALLET_LOCATION ${ORACLE_HOME}/network/admin/sqlnet.ora | wc -l`
if [ $HAS_WALLET_ENTRY -gt 0 ]; then
 echo 
 echo "The sqlnet.ora has an old parameter in it. We are going to remove it first."
 echo 
 cp ${ORACLE_HOME}/network/admin/sqlnet.ora ${ORACLE_HOME}/network/admin/sqlnet.ora.has_wallet_location

 # We need to delete these lines. 
 # ENCRYPTION_WALLET_LOCATION=
 #  (SOURCE=(METHOD=FILE)(METHOD_DATA=
 #  (DIRECTORY=$ORACLE_BASE/admin/$ORACLE_SID/wallet/)))

 sed -i '/ENCRYPTION_WALLET_LOCATION/d' ${ORACLE_HOME}/network/admin/sqlnet.ora
 sed -i '/METHOD_DATA/d' ${ORACLE_HOME}/network/admin/sqlnet.ora
 sed -i '/\DIRECTORY\=/d' ${ORACLE_HOME}/network/admin/sqlnet.ora

 echo 
 echo "Let's view the sqlnet.ora now..."
 echo 
 cat ${ORACLE_HOME}/network/admin/sqlnet.ora

fi 
