##########################################################################
# Program:  chkdb
# Purpose:  Monitor the databases listed in the chkdb.lst file.
#           The program ensures the instances are up and operational.
# Engineer: Barry Spalding
# Date:     8/1/96
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes
ID="system"
HOST=`hostname`

echo "`date`"
#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
    echo $SERVICE >> ./logs/chkdb.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> ./logs/chkdb.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   set pause off
   select count(*) from sys.dba_users;
   exit
END
   if [ $? -eq 5 ]; then
     echo "******* $SERVICE is not responding."
     #mail -s "Error - $SERVICE not responding." $OWNER < /tmp/chkdb.out
   else
     echo "All is well on $SERVICE."
   fi

 done

