########################################################################
# Program:  New_Ora_SW_11g_Base.sh
# Purpose:  Create new 11g Oracle Software Baseline for SW Monitoring 
#           (ORA SRR 4.5 - STIG DG0010)
# Engineer: Jason Cline 
# Date:     December 2009
##########################################################################
. /u10/app/oracle/.profile11

export Base11g=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_11g_base.log

ls -aR $OH > $Base11g

echo "New 11g Baseline created as $Base11g"

exit
