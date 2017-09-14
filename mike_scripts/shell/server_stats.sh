#!/bin/ksh

# First, we must set the environment . . . .
ORACLE_SID=BURLESON
export ORACLE_SID
ORACLE_HOME=`cat /etc/oratab|\
grep \^$ORACLE_SID:|cut -f2 -d':'`
export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH
export PATH
MON=`echo ~oracle/mon`
export MON

SERVER_NAME=`uname -a|awk '{print $2}'`
typeset -u SERVER_NAME
export SERVER_NAME

# sample every five minutes (300 seconds) . . . .
SAMPLE_TIME=300

while true
do
   vmstat ${SAMPLE_TIME} 2 > /tmp/msg$$

# This script is intended to run starting at 
# 7:00 AM EST Until midnight EST
cat /tmp/msg$$|sed 1,4d | awk  '{ \
printf("%s %s %s %s %s %s %s\n", $1, $6, $7,\
 $14, $15, $16, $17) }' | while read RUNQUE\
 PAGE_IN PAGE_OUT USER_CPU SYSTEM_CPU\
 IDLE_CPU WAIT_CPU
   do

      $ORACLE_HOME/bin/sqlplus -s / <<EOF
      insert into mon_vmstats values (
                             sysdate, 
                             $SAMPLE_TIME,
                             '$SERVER_NAME',
                             $RUNQUE,
                             $PAGE_IN,
                             $PAGE_OUT,
                             $USER_CPU,
                             $SYSTEM_CPU,
                             $IDLE_CPU,
                             $WAIT_CPU 
                                  );
      EXIT
EOF
   done
done

rm /tmp/msg$$
