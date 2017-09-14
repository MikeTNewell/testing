. /u10/app/oracle/.profile

export srvr=`hostname -s`

export DB10=/u10/app/oracle/scripts/cleanup/logs/10g_dbs.log
export DB11=/u10/app/oracle/scripts/cleanup/logs/11g_dbs.log

cat /etc/oratab | grep -v "11.1.0" | awk -F: '{print $1}' | grep -v "#"  > $DB10
cat /etc/oratab | grep -v "10.2.0" | awk -F: '{print $1}' | grep -v "#"  > $DB11

export TIMESTAMP="`date '+%d%b%Y  %r'`"

export LOG=/u10/app/oracle/scripts/monitor/logs/alert_log.log

rm $LOG

echo "ALERT LOG ERRORS" > $LOG
echo $TIMESTAMP >> $LOG
echo '' >> $LOG
echo '' >> $LOG

# 10g databases

for DB in `cat $DB10`
do
SID=$DB
AL10=/u10/app/oracle/admin/$SID/bdump/alert_$SID.log
ARC10=/u10/app/oracle/admin/$SID/bdump/alert_"$SID"_arc.log

echo $SID >> $LOG
cat $AL10 | grep ORA- >> $LOG
cat $AL10 >> $ARC10
rm $AL10
echo '' >>$LOG
echo '' >>$LOG

done

# 11g databases

for DB in `cat $DB11`
do
SID=$DB
AL11=/u10/app/oracle/diag/rdbms/$SID/$SID/trace/alert_$SID.log
ARC11=/u10/app/oracle/diag/rdbms/$SID/$SID/trace/alert_"$SID"_arc.log

echo $SID >> $LOG
cat $AL11 | grep ORA- >> $LOG
cat $AL11 >> $ARC11
rm $AL11
echo '' >>$LOG
echo '' >>$LOG

done

#email log if any errors

grep ORA- $LOG > /dev/null
if [ $? -eq 0 ]    #0=found 1=notfound
  then
    cat $LOG | mailx -s "${srvr} ALERT LOG ERRORS" dbasup@logistics.navair.navy.mil
fi
