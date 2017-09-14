##########################################################################
# Program:  gen_usr_qry
# Purpose:  query each database in chkdb to determine if selected user exists
# Engineer: Jason Cline (modified from Barry Spalding script)
# Date:     7/22/2008
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes
ID="system"
HOST=`hostname`

cd $ORACLE_BASE/scripts/misc/logs/

echo "`date`" > gen_usr_qry.out
echo "What user do you wish to find?"
read USER

#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
   echo '*************************************************************' >> gen_usr_qry.out
   echo $SERVICE "  " $USER >> gen_usr_qry.out
   echo '*************************************************************' >> gen_usr_qry.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> gen_usr_qry.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   select account_status from dba_users where username = '$USER';
   exit
END
 if [ $? -eq 5 ]; then
     echo "******* $SERVICE is not responding."
   else
     echo "Querying $SERVICE for $USER."
 fi 
done

mail -s "Database query for $USER" jason.cline.ctr@navy.mil < gen_usr_qry.out
