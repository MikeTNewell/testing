#
########################################################################
# Program:  Oracle Security Review Script`
# Purpose:  Verify Srr Number found in script name
# Engineer: Jason Cline (modified from Barry Spalding script)
# Date:     2009
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes

rm ./logs/SRR7.37.out
ID="system"
HOST=`hostname`

nohup echo "`date`" > ./logs/SRR7.37.out
#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
    echo >> ./logs/SRR7.37.out
    echo >> ./logs/SRR7.37.out
    echo "**********" $SERVICE "**********" >> ./logs/SRR7.37.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> ./logs/SRR7.37.out 2>&1  <<END
   whenever sqlerror exit 5
   connect $ID/$PASSWORD@$SERVICE
select count(*) from v\$parameter
where name='dispatchers'
and value like '%XDB%';
   exit
   echo \n >> ./logs/SRR7.37.out
   echo \n >> ./logs/SRR7.37.out
END

 done

cat ./logs/SRR7.37.out | mailx -s "Oracle SRR 7.37" jason.cline.ctr@navy.mil

