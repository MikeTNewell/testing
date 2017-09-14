##########################################################################
# Program:  list_invalid_objects.sh
# Purpose:  Query all databases for invalid objects 
# Engineer: Josh Colliflower (modified from Barry Spalding script)
# Date:     5/30/2008
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes
ID="system"
HOST=`hostname`

cd $ORACLE_BASE/scripts/misc/logs/
rm ./list_invalid_objects.out
echo "`date`" > list_invalid_objects.out

#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
   echo '*************************************************************' >> list_invalid_objects.out
   echo $SERVICE >> list_invalid_objects.out
   echo '********************' >> list_invalid_objects.out
   echo '********************' >> list_invalid_objects.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> list_invalid_objects.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   set pause off
   set feedback off
   set pagesize 25
   column owner format a20;
   column object_name format a40 word_wrapped;
   select owner, object_name from dba_objects where status = 'INVALID' order by owner;

   select count(*) as TOTAL_INVALID_OBJECTS from dba_objects where status = 'INVALID';
   exit
END
 if [ $? -eq 5 ]; then
     echo "******* $SERVICE is not responding."
   else
     echo "All is well on $SERVICE."
 fi 
done

