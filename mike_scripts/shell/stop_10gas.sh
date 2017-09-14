#
# Stop Middle Tier
#
clear
printf "\n\nStopping 10gAS...\n"
export ORACLE_SID=iasdbvm
export ORACLE_HOME=/u001/10gAS/bi_10g
OLDPATH=$PATH
OLDLIBPATH=$LD_LIBRARY_PATH
export PATH=.:$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
export DISPLAY=dallinux46:0
export INFRA=vminfra.dallinux46.clubcorp.com

printf "\nStopping middle tier...\n"
$ORACLE_HOME/opmn/bin/opmnctl stopall
$ORACLE_HOME/bin/emctl stop iasconsole

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

#
# Stop Oracle Portal and Wireless 
#
printf "\nStopping Portal and Wireless...\n"
export ORACLE_HOME=/u001/10gAS/Portal_10g
OLDPATH=$PATH
export LD_LIBRARY_PATH=$OLDLIBPATH:$ORACLE_HOME/lib
export PATH=.:$ORACLE_HOME/bin:$OLDPATH
$ORACLE_HOME/opmn/bin/opmnctl stopall
$ORACLE_HOME/bin/emctl stop iasconsole

printf "\n\n\nChecking for remaining processes...\n"
ps -fu $USER|egrep -v 'bash|ksh|ssh|stop_10gas|ps -fu'

