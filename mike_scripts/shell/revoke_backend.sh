##########################################################################
# Program:  revoke_dev_bknd_role.sh
# Purpose:  To revoke backend role from specified user acct
# Engineer: Jason Cline (modified from Barry Spalding script)
# Date:     1/21/2009
##########################################################################

. ~oracle/.profile > /dev/null #done for cron purposes

rm ./logs/revoke_dev_bknd_role.out
ID="system"
HOST=`hostname`

echo "Enter user account to revoke roles: "
read USER

nohup echo "`date`" > ./logs/revoke_dev_bknd_role.out
#Attempt to connect to the various machines/instances
 for i in `grep -v "+" $ORACLE_BASE/scripts/monitor/chkdb.lst`
 do
   SERVICE="`echo $i | awk -F: '{print $1}'`"
   PASSWORD="`echo $i | awk -F: '{print $2}'`"
    echo "***************" $SERVICE "***************" >> ./logs/revoke_dev_bknd_role.out
   $ORACLE_HOME/bin/sqlplus -s /nolog  >> ./logs/revoke_dev_bknd_role.out 2>&1  <<END
   connect $ID/$PASSWORD@$SERVICE
   set feedback on
   revoke backend from $USER;
   exit
END

 done

cat ./logs/revoke_dev_bknd_role.out | mailx -s "Backend Revoke" jason.cline.ctr@navy.mil

