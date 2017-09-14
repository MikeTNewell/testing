#!/bin/ksh
#/u10/app/oracle/scripts/sftp/ftpup.sh
mylog=./logs/sftp_login.log
echo "$(date "+%H:%M:%S") - Attempt to FTP new LOGIN.sh files" > $mylog

cp -p /u10/app/oracle/login.sh /u10/app/oracle/scripts/sftp/login.sh

sftp logistics01 <<EndFTP >> $mylog
cd /u10/app/oracle
put login.sh
bye
End

sftp logistics02 <<EndFTP >> $mylog
cd /u10/app/oracle
put login.sh
bye
EndFTP

sftp logistics03 <<EndFTP >> $mylog
cd /u10/app/oracle
put login.sh
bye
EndFTP
