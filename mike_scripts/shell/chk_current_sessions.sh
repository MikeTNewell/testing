##########################################################################
# Program:  chk_current_sessions.sh
# Purpose:  Queries all dbs to view current sessions
# Engineer: Jason Cline (modified from Barry Spalding script)
# Date:     8/12/2008
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes

rm ./logs/chk_sess.out
ID="system"
HOST=`hostname`

nohup echo "`date`" > ./logs/chk_sess.out
#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
    echo "**********" $SERVICE "**********" >> ./logs/chk_sess.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> ./logs/chk_sess.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   select distinct username from v\$session
   order by username;
   exit
END

 done

cat ./logs/chk_sess.out | mailx -s "Current Sessions" jason.cline.ctr@navy.mil

