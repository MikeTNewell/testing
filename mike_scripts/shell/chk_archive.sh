#!/bin/ksh

# Author:  Barry Spalding
# Purpose: Monitor the operating system's avaiable space in the archive dir
#          Send an e-mail when space is less than the passed minimum value.
# Date:    06/04/2004

FILE_DIR=/u10/app/oracle/scripts/monitor

rm $FILE_DIR/logs/chk_archive.out
date > $FILE_DIR/logs/chk_archive.out
MAIL_FLAG='FALSE'

df -k | grep archive | grep -v used | while read LINE
do
   PERCENT=`echo $LINE | awk '{print $4}' | awk -F% '{print $1}'`
   if [ $PERCENT -ge $1 ]; then
      MAIL_FLAG='TRUE'
      HOSTNAME=`hostname`
      MOUNT_POINT=`echo $LINE | awk '{print $7}'`
      MEG=`echo $LINE | awk '{print $3}'`
      let MEG=MEG/1024
      echo $HOSTNAME $MOUNT_POINT" is "$PERCENT "% full. $MEG MB Remaining.--"\ >> $FILE_DIR/logs/chk_archive.out
      echo " " >> $FILE_DIR/logs/chk_archive.out
   fi;
done;
if [ $MAIL_FLAG = TRUE ]; then
   mail -s"WARNING!!: Archive Space Problems on $HOSTNAME" dbasup@logistics.navair.navy.mil < $FILE_DIR/logs/chk_archive.out
fi;
