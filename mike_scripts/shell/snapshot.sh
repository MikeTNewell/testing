. /u10/app/oracle/.profile11
. /u10/app/oracle/login.sh

echo "DECKTD: `date`" >> /u10/app/oracle/scripts/tune/logs/snap_decktd.log
sqlplus <<EOF
$PERFSTAT @decktd_dev
set echo off
set head off
set feedback off
spool /u10/app/oracle/scripts/tune/logs/snap_decktd.log append 
execute statspack.snap; 
select max(snap_id) from stats\$snapshot; 
spool off 
exit 
EOF

#echo "SCAR: `date`" >> /u10/app/oracle/scripts/tune/logs/snap_scar.log
#sqlplus <<EOF
#$PERFSTAT @scar_dev
#set echo off
#set head off
#set feedback off
#spool /u10/app/oracle/scripts/tune/logs/snap_scar.log append
#execute statspack.snap;
#select max(snap_id) from stats\$snapshot;
#spool off
#exit
#EOF
