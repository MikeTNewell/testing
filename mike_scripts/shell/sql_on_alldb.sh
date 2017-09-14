##########################################################################
# Program:  
# Purpose:  query each database in chkdb to determine if 
# Engineer:  (modified from Barry Spalding script)
# Date:     
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes
ID="system"
HOST=`hostname`

cd $ORACLE_BASE/scripts/misc/logs/

echo "`date`" > sql_on_alldb.out
echo "Enter database query (end query with ;):"
read QUERY
echo "Enter email address:"
read EMAIL

#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
   echo '' >> sql_on_alldb.out
   echo '*************************************************************' >> sql_on_alldb.out
   echo $SERVICE "  " $QUERY >> sql_on_alldb.out
   echo '*************************************************************' >> sql_on_alldb.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> sql_on_alldb.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   $QUERY
   exit
END
 if [ $? -eq 5 ]; then
     echo "******* $SERVICE is not responding."
   else
     echo "Querying $SERVICE for $USER."
 fi 
done

mail -s "Database query $QUERY" $EMAIL < sql_on_alldb.out
