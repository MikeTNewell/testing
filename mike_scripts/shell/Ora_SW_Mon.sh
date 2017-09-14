########################################################################
# Program:  Ora_SW_Mon
# Purpose:  Monitor Oracle Application Software for changes 
#           (ORA SRR 4.5 - STIG DG0010)
#           Compares Oracle Homes to baseline to see if any files changed.
#           Verify differences in report then run scripts to create new
#           baselines (new_ora_sw_10g_base.sh and new_ora_sw_11g_base.sh
# Engineer: Jason Cline 
# Date:     December 2009
##########################################################################
. /u10/app/oracle/.profile

export Log10g=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_10g_wkly.log
export Base10g=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_10g_base.log
export Log11g=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_11g_wkly.log
export Base11g=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_11g_base.log
export LOG=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_Diffs.log

ls -aR $OH > $Log10g

. /u10/app/oracle/.profile11

cd $OH/rdbms/audit
mv ./rman* /oraaudit/rman

ls -aR $OH > $Log11g

print "`date`" > $LOG
echo "********10g Oracle Home Differences********" >> $LOG
diff -b $Base10g $Log10g >> $LOG
echo >> $LOG
echo >> $LOG
echo "********11g Oracle Home Differences********" >> $LOG
diff -b $Base11g $Log11g >> $LOG

cat $LOG | mailx -s "Log04 Oracle Home Software Change Report" dbasup@logistics.navair.navy.mil
exit
