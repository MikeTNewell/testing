ORACLE_SID=<SID>
ORACLE_HOME=`cat /etc/oratab|\
grep \^$ORACLE_SID:|cut -f2 -d':'`
LOGDIR=$ORACLE_BASE/scripts/$ORACLE_SID/log

$ORACLE_HOME/bin/sqlplus -s / >> $LOGDIR/logname.log 2>&1  <<EOF

  select sysdate from dual;

  select sysdate -1 from dual;

  exit

EOF

cat $LOGDIR/logname.log | mailx -s "Blah Blah Blah" joey.tapponnier@scipax.com

rm $LOGDIR/logname.log
