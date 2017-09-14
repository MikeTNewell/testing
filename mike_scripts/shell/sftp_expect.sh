#!/bin/ksh
#-----------------------------------------------------------------
# This is a generic sftp script used to execute ftp commands
# in batch mode.  Note: this script uses expect commands to be
# interactive.
#   Batch file parameters list in order:
#	get or put			($1)
#	Local Directory                 ($2)
#	Local File Name                 ($3)
#	Destination Server              ($4)
#	Destination Directory           ($5)
#       Remove Destination file y/n     ($6)
#       Remove original file y/n        ($7)
#
# David Knight
# Date: 03/21/06
#
# Modified by Mike Newell on 08/27/07
# 
# Note: On Unix the -B argument is used to specify the batch file.
# on Linux -b (Lowercase) needs to be used.
#-----------------------------------------------------------------
#if [ -f /etc/redhat-release ] ; then
#        echo "If you want to copy this script from Unix to"
#        echo "Linux you will first need to change the -B arg"
#        echo "in the two sftp commands to a lowercase -b"
#        echo "Then remove this if statement."
#        echo "Form more information man sftp on Linux and Unix"
#        echo "Thanks, your friendly Admin."
#        exit 78
#fi
#-----------------------------------------------------------------
set +x
TERM=vt100
# Pass the arguments
CMD=$1
LCD=$2
FLNM=$3
SYSTEM=$4
CD=$5
PASSWORD=`zcat $HOME/.ssh/test.pwd`
# Check number of args passwd
if [ $# -lt 7 ]; then
	echo "Please pass seven args."
	exit 2 
fi
# Check $6 and $7 for correct syntax
case $6 in
        [n,N]) continue ;;
        [y,Y]) continue ;;
        *) echo "Check param 6" ; exit 11 ;;
esac
case $7 in
        [n,N]) continue ;;
        [y,Y]) continue ;;
        *) echo "Check param 6" ; exit 12 ;;
esac

# Set Batch file and Log File Names PID of sftp.ksh script
# is appended to end of the batch and log file name.
BFILE=/tmp/sftp.batch.$$ ; export BFILE
LFILE=/tmp/sftp.log.$$ ; export LFILE

# init $ERR to 0
ERR=0

# Valadate function checks the output of sftp transfer for errors.
validate() {
set -A TOCHECK failed warning error Couldn
for i in ${TOCHECK[@]}; do
        grep -i $i $LFILE
        if [ $? -eq 1 ]; then
                ERR=2
        fi
done
# Added error checking specifically for a correct transfer or errors - mtn
grep 'Uploading' $LFILE
if [ $? -gt 0 ]; then
	grep 'Couldn' $LFILE
	if [ $? -eq 0 ]; then
		grep "No such file" $LFILE
		if [ $? -eq 0 ]; then
			ERR=16
		else
			ERR=21
		fi
	else
		grep 'denied' $LFILE
                if [ $? -eq 0 ]; then
			ERR=6
		else
			ERR=0
		fi
	fi
else
	ERR=0
fi
grep "not found" $LFILE
if [ $? -eq 0 ]; then
	ERR=49
fi
}

# If you do not want to overwrite the remote file name
# we will check to see if it is there. If so exit 5.
if [ $6 = n ] || [ $6 = N ]; then
/usr/bin/expect <<EOF >$LFILE
	spawn /usr/bin/sftp $SYSTEM
	sleep 7
	expect "$SYSTEM's password:"
	send "$PASSWORD\r"
	sleep 5
	expect "sftp> "
	send "lcd $LCD\r"
	expect "sftp> "
	send "cd $CD\r"
	expect "sftp> "
	send "ls $FLNM\r"
	expect "sftp> "
	send "bye \r"
EOF
        grep "no such file" $LFILE
        if [ $? -gt 1 ]; then
                echo "Remote file Exists"
                exit 5
        fi
fi

# If you don't care if you overwrite the remote file or it doesn't exist.
# Create the file transfer batch file.
/usr/bin/expect <<EOF >$LFILE
spawn /usr/bin/sftp $SYSTEM
sleep 7
expect "$SYSTEM's password:"
send "$PASSWORD\r"
sleep 5
expect "sftp> "
send "lcd $LCD\r"
expect "sftp> "
send "cd $CD\r"
expect "sftp> "
send "$CMD $FLNM\r"
sleep 10
expect "sftp> "
send "bye \r"
EOF

# Run the validate function to verify transfer.
# If we find error then exit 7 else remove the
# Batch and log file and remove local file if you
# requested in $7
validate
if [ $ERR -gt 0 ]; then
                 echo "sftp failed, Please check $LFILE for details"
                 exit $ERR
else
                 [ -f $BFILE ] && rm $BFILE
                 if [ $7 = y ] || [ $7 = Y ]; then
                        cd $2
                        rm $3
# Checks prompt 6 for a yes and remove the remote file.
# - Changed by mtn on 6-11-07
                 elif [ $6 = y ] || [ $6 = Y ]; then
/usr/bin/expect <<EOF > $LFILE
			spawn /usr/bin/sftp $SYSTEM
			sleep 7
			expect "$SYSTEM's password:"
			send "$PASSWORD\r"
			sleep 5
			expect "sftp> "
			send "lcd $LCD\r"
			expect "sftp> "
			send "cd $CD\r"
			expect "sftp> "
			send "rm $CM"
EOF
		 #[ -f $LFILE ] && rm $LFILE
		 #[ -f $BFILE ] && rm $BFILE
                 fi
fi

