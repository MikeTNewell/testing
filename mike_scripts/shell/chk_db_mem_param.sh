##########################################################################
# Program:  chk_db_mem_param.sh
# Purpose:  query all databases for processes parameters
# Engineer: Jason Cline (modified from Barry Spalding script)
# Date:     5/30/2008
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes

rm ./logs/chk_db_mem_param.out
ID="system"
HOST=`hostname`

nohup echo "`date`" > ./logs/chk_db_mem_param.out
#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
    echo "**********" $SERVICE "**********" >> ./logs/chk_db_mem_param.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> ./logs/chk_db_mem_param.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
   set pause off
   set pagesize 50
   set head on
   set pause off
   set linesize 140
show parameter pga_aggregate_target;
show parameter sga_target;
   exit
END

 done

cat ./logs/chk_db_mem_param.out | mailx -s "Oracle Database Memory Parameters" joseph.tapponnier@navy.mil 

