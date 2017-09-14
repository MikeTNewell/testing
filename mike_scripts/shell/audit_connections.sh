#!/bin/ksh
for db in `cat /etc/oratab | egrep ':N|:Y'| grep -v \* | cut -f1 -d':'`
do
   home=`cat /etc/oratab | egrep ':N|:Y'| grep -v \* | cut -f2 -d':'`
   echo "************************"
   echo "database is $db"
   echo "************************"
   export ORAENV_ASK=NO
   . oraenv
   ORACLE_SID=${db};export ORACLE_SID 
   ORACLE_HOME=${home};export ORACLE_HOME
   PATH=$PATH:$ORACLE_HOME/bin
${home}/bin/sqlplus / as sysdba <<END
SELECT count(*)
FROM ORAAUDIT.AUD$ A
where logoff$time >= to_char(sysdate - 8)
and logoff$time <= to_char(sysdate - 3)
and returncode = 0
GROUP BY RETURNCODE;
exit
END
done
