########################################################################
# Program:  New_Ora_SW_10g_Base.sh
# Purpose:  Create new 10g Oracle Software Baseline for SW Monitoring 
#           (ORA SRR 4.5 - STIG DG0010)
# Engineer: Jason Cline 
# Date:     December 2009
##########################################################################
. /u10/app/oracle/.profile

export Base10g=/u10/app/oracle/scripts/monitor/logs/Ora_SW_Mon_10g_base.log

ls -aR $OH > $Base10g

echo "New 10g Baseline created as $Base10g"

exit
