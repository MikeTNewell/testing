clear
printf "\n\nStopping 10gAS...\n"
export ORACLE_SID=iasdbvm
OLDPATH=$PATH
OLDLIBPATH=$LD_LIBRARY_PATH
#
# Stop Oracle Identity Management
#
printf "\nStopping infrastructure...\n"
export ORACLE_HOME=/u001/10gAS/infra_10g
OLDPATH=$PATH
export LD_LIBRARY_PATH=$OLDLIBPATH:$ORACLE_HOME/lib
export PATH=.:$ORACLE_HOME/bin:$OLDPATH
$ORACLE_HOME/opmn/bin/opmnctl stopall
$ORACLE_HOME/bin/emctl stop iasconsole

# Stop RDBMS Listener
printf "\nStopping listener...\n"
$ORACLE_HOME/bin/lsnrctl stop LISTENER

# Shutdown Repository database
printf "\nShutting down repository database\n"
sqlplus -s '/ as sysdba' <<!
shutdown immediate
exit
!

printf "\n\n\nChecking for remaining processes...\n"
ps -fu $USER|egrep -v 'bash|ksh|ssh|stop_10gas|ps -fu'

