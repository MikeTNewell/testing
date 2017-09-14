#!/bin/sh
# USAGES: Shell script to KILL Zombie Process
# Author: AMIT MAHESHWARI
# Website : http://linux.amitmaheshwari.in/
# version: 0.1

# Command Variable
Cmd_echo=`which echo`
Cmd_ps=`which ps`
Cmd_awk=`which awk`
Cmd_grep=`which grep`
Cmd_sed=`which sed`
Cmd_kill=`which kill`
Cmd_date=`which date`
TIMESTAMP="$Cmd_date +%Y%m%d-%T"
Log_path="/tmp/$TIMESTAMP"

#SCRIPT START
ZOMBIE=`$Cmd_ps ax | $Cmd_awk '{print $3" "$1 $5}' | $Cmd_grep -e ^'Z ' | $Cmd_sed 's/Z //1'`
if [ -z "$ZOMBIE" ]
        then
        $Cmd_echo "No Zombie Process Found"
        else
        $Cmd_echo "$ZOMBIE"
        $Cmd_kill -HUP `$Cmd_ps -A -ostat,ppid | $Cmd_grep -e '^[Z]' | $Cmd_awk '{print $2}'`
        $Cmd_echo "Zombie Process Killed"
fi
#SCRIPT END
