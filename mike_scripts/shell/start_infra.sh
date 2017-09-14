export ORACLE_SID=iasdbvm
export ORACLE_HOME=/u001/10gAS/infra_10g
OLDPATH=$PATH
export PATH=.:$ORACLE_HOME/bin:$PATH
export DISPLAY=dallinux16:0
export INFRA=vminfra.dallinux16.clubcorp.com

clear
printf "\nStarting prod_disc Services....\n"
printf "\nStarting listener...\n"

$ORACLE_HOME/bin/lsnrctl start LISTENER

printf "\nStarting repository database...\n"

sqlplus -s '/ as sysdba' <<!
startup
exit
!
#
# Start Oracle Identity Management
#
printf "\nStarting Oracle Infrastructure Layer\n"
$ORACLE_HOME/opmn/bin/opmnctl startall
$ORACLE_HOME/bin/emctl start iasconsole
$ORACLE_HOME/dcm/bin/dcmctl getState -v -i $INFRA

