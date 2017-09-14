##########################################################################
# Program:  chk_current_sessions.sh
# Purpose:  Queries all dbs to view current sessions
# Engineer: Jason Cline (modified from Barry Spalding script)
# Date:     8/12/2008
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes

rm ./logs/concurr_sess.out
LOG=/u10/app/oracle/scripts/misc/logs/concurr_sess.out
ID="system"
HOST=`hostname`

nohup echo "`date`" > $LOG
#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst.prd`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
    echo "**********" $SERVICE "**********" >> $LOG
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> $LOG 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   select count(*) from v\$session
   where username IS NOT NULL;
   exit
END

 done

cat $LOG | mailx -s "Concurrent Sessions" jason.cline.ctr@navy.mil

