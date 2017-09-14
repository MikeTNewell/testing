#!/bin/bash

clear
echo '--------------------------------------------------------------------------------------------------------------'
echo '	                               Server Report'
echo '	                               -------------'
a=`date|awk -F' ' '{print $2,$3}'`
b=`date +%r|awk -F ':' '{print $1}'`
c=`date +%r|awk -F ':' '{print $2}'`
d=`date +%r|awk -F ' ' '{print $2}'`
echo -e "\tDate: $a, `date +%Y` $b:$c $d                            By: `whoami`
"
#------------------------------------------------------------------------------------------------
echo '	Basic Server Information'
echo '	------------------------'
	if [ `uname -m` = 'i686' ]; then
		e='32 bit'
	   else
		e='64 bit'
	fi
f=`uptime|cut -d ' ' -f5|cut -d':' -f1`
i=`uptime|cut -d ' ' -f5|cut -d':' -f2|cut -d',' -f1`
j=`ps|wc -l`
echo -e "\tIP Address    :        `hostname -i|cut -d' ' -f1` "
echo -e "\tHostname      :        `hostname` "
echo -e "\tOS            :        `uname`"
echo -e "\tKernel        :        `uname -r |cut -d '-' -f1`"
echo -e "\tArchitecture  :        `uname -m` - $e
					      "
		if [ $f = 'min,' ];then
			echo -e "\tUp time           :        `uptime|cut -d ' ' -f4` Minutes"
		elif [ `uptime|cut -d ' ' -f5` = days, ]; then
			echo -e "\tUp time           :        `uptime|cut -d ' ' -f4,5|cut -d ',' -f1`"
		else		 
			echo -e "\tUp time           :        $f Hours $i Minutes"

		fi
echo -e "\tCurrent Users     :        `who|wc -l`"
echo -e "\tCurrent processes :        `expr $j - 4`"
echo -e "\tCPU usage         :        `mpstat|tail -1|awk -F' ' '{print 100-$12}'` (Threshold 85%, 90%)"
echo -e "\tMemory Usage      :        `free -m|head -2|tail -1|tr -s ' '|awk -F' ' '{printf "%dMB out of %dMB",$3,$2}'` (Threshold 90%, 95%)"
echo -e "\tSystem Load       :        `uptime|tr -s ' '|cut -d' ' -f11|cut -d',' -f1` (1 minute), `uptime|tr -s ' '|cut -d' ' -f12|cut -d',' -f1` (5 minute),  `uptime|tr -s ' '|cut -d' ' -f13|cut -d',' -f1` (15 minute)
																    "
#-------------------------------------------------------------------------------------------------
echo "	Process Load (processes taking higher resources)"
echo "	------------------------------------------------"
ps aux | sort -rk 3,3 | head -12 | awk -F' ' '{printf "\t%-13s%-6s%-5s%-7s%s\n",$1,$2,$3,$10,$11}'
echo "
	"
#-------------------------------------------------------------------------------------------------
echo "	List of Users Currently Logged in(sorted by number of sessions)"
echo "	---------------------------------------------------------------"
who|cut -d ' ' -f1|uniq -c|sort -rnk1|awk -F' ' '{printf "%-12s%s\n",$2,$1}' > temp10.txt
        while read l
      do
        if [ `echo $l|tr -s ' '|cut -d' ' -f2` -eq 1 ]; then
          echo -e "\t`echo $l|awk -F' ' '{printf "%-15s: %s session",$1,$2}'`"
        else
          echo -e "\t`echo $l|awk -F' ' '{printf "%-15s: %s sessions",$1,$2}'`"
        fi
      done < temp10.txt
rm -rf temp10.txt
echo -e "\n"
#------------------------------------------------------------------------------------------------
echo "	Storage Information"
echo "	-------------------"
parted /dev/vda print free|grep -i '^Disk /dev/'|cut -d' ' -f2|cut -d':' -f1 > temp11.txt
	n=1
	while read m
      do
	echo -e "\tDisk no. $n" 
        echo -e "\tName         : $m" 
        echo -e "\tSize         : `parted $m print free|head -2|tail -1|cut -d' ' -f3`"
        echo -e "\tFree Space   : `parted $m print free|head -7|tail -1|tr -s ' '|cut -d' ' -f4` 
						  					    "
	n=`expr $n + 1`
      done < temp11.txt
rm -rf temp11.txt
#-------------------------------------------------------------------------------------------------
echo "	Partition/File System Information  (Threshold 80% & 85%)"
echo "	--------------------------------------------------------"
function file
{
df -h | grep vda > /dev/null
if [ $? -eq 0 ]; then
   parted /dev/vda print free|tail -7|head -5|awk -F ' ' '{printf "\t %s. /dev/vda%-5s %-10s %-15s %-7s %-s \n",$1,$1,$5,$6,$4,$7}'
else
   break
fi

df -h | grep vdb > /dev/null
if [ $? -eq 0 ]; then
    parted /dev/vdb print free|tail -7|head -5|awk -F ' ' '{printf "\t %s. /dev/vda%-5s %-10s %-15s %-7s %-s \n",$1,$1,$5,$6,$4,$7}'
else
   echo " "
fi
}

file
echo -e "\n"
#-----------------------------------------------------------------------------------------------
echo "	LVM Information"
echo "	---------------"

echo "	LV                                VG                     Size            Mount Point"
echo "	-----                            ----                   ------           -----------" 
lvdisplay|grep "LV Name"|tr -s ' '|cut -d ' ' -f4 >temp19.txt
		while read lv1
		do 
		echo -e "\t`lvdisplay|grep $lv1|grep "LV Path"|tr -s ' '|awk -F' ' '{printf "%-20s",$3}'`\t\t`lvdisplay|grep $lv1|grep "LV Name"|tr -s ' '|awk -F' ' '{printf"%-10s",$3}'`\t\t`lvs|grep $lv1|tr -s ' '|awk -F' '  '{printf "%-15s",$4}'` `df -P|grep $lv1|tr -s ' '|cut -d ' ' -f6`"
		done < temp19.txt
rm -rf temp19.txt

echo -e "\n	PV		VG	       Size"
echo "	-------		-----       --------"
echo "	`pvs|tail -n +2|tr -s ' '|awk -F ' ' '{printf "%-15s%-15s%s",$1,$2,$5}'`"
#-------------------------------------------------------------------------------------------------
echo -e "\n"
echo "	I/O Statistics"
echo "	--------------"
echo -e "\tCPU Average I/O Wait: `iostat |head -4|tail -1|tr -s ' '|cut -d ' ' -f5`% \n"
iostat|tail -5|tr -s ' '|awk -F' ' '{printf "\t%-12s%-12s%s\n",$1,$3,$4}'

#-------------------------------------------------------------------------------------------------
echo "	Network Information"
echo "	-------------------"
ip addr show|grep "scope global eth"|tr -s ' ' > temp12.txt
                while read aa
                do 
                        ab=` echo $aa|grep "scope global eth"|tr -s ' '|cut -d' ' -f7`
                        ac=`ip addr show $ab|grep -iw "scope global $ab"|tr -s ' '|cut -d' ' -f3|cut -d'/' -f1`
                        ad=`echo $ac|cut -d'.' -f1`



                if [ $ad -le 127 ];then
                        echo -e "\t`echo $ab|awk -F ' ' '{printf "%-15s",$1}'`: $ad (Class A)"
                elif [ $ad -ge 128 -a $ad -le 191 ];then
                        echo -e "\t`echo $ab|awk -F ' ' '{printf "%-15s",$1}'`: $ad (Class B)"
                elif [ $ad -ge 192 -a $ad -le 223 ];then
                        echo -e "\t`echo $ab|awk -F ' ' '{printf "%-15s",$1}'`: $ad (Class C)"
                elif [ $ad -ge 224 -a $ad -le 239 ];then
                        echo -e "\t`echo $ab|awk -F ' ' '{printf "%-15s",$1}'`: $ad (Class D)"
                elif [ $ad -ge 240 -a $ad -le 255 ];then
                        echo -e "\t`echo $ab|awk -F ' ' '{printf "%-15s",$1}'`: $ad (Class E)"
                else echo 'Invalid'
                fi
                done < temp12.txt
rm -rf temp12.txt




ls /etc/sysconfig/network-scripts/ifcfg-lo* > temp13.txt
		while read ae
		do
		    echo -e "\t`cat $ae|grep -i "^DEVICE"|cut -d'=' -f2`             : `cat $ae|grep IPADDR|cut -d'=' -f2`"
		done < temp13.txt
rm -rf temp13.txt

echo -e "\thostname       : `hostname|cut -d'.' -f1`"
echo -e "\tDomain         : `hostname|cut -d'.' -f2,3,4,5,6`"
echo -e "\tDNS Server     : `cat /etc/resolv.conf |grep nameserver|tr -s ' '|cut -d' ' -f2`"
echo -e "\tGateway Server : `cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep -w ^GATEWAY|cut -d'=' -f2`"

q=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |grep -i dhcp|wc -l`
		if [ $q -ne 0 ]; then
			echo -e "\tDHCP Enabled   : YES"
		else	echo -e "\tDHCP Enabled   : NO"
		fi
echo -e "\tMAC Address    : `cat /etc/sysconfig/network-scripts/ifcfg-eth0|grep -i ^HWADDR|cut -d'=' -f2|cut -d'"' -f2`"

r=`cat /proc/sys/net/ipv4/ip_forward`
		if [ $r -eq 0 ];then
			echo -e "\tIP Forwarding enabled : NO"
		else	echo -e "\tIP Forwarding enabled : YES"
		fi

s=`service iptables status|wc -l`
		if [ $s -eq 1 ]; then
			echo -e "\tFirewall On           : NO"
		else	echo -e "\tFirewall On           : YES"
		fi
t=`netstat -lntu|grep -i LISTEN|tr -s ' '| cut -d ' ' -f1|uniq`
echo -e "\tList of open ports    : $t
"


#-------------------------------------------------------------------------------------------------
echo "	Network Connections"
echo "	-------------------"
echo -e "\tCurrent Connections (TCP) : `netstat -n -A inet|tail -n +3|wc -l`"
echo -e "\tConnections from the following IPs:"
netstat -n -A inet|tail -n +3|tr -s ' '|cut -d' ' -f5|cut -d':' -f1|sort|uniq > temp18.txt
			an=1
			while read ao
			do
			echo "		$an. $ao"
			an=`expr $an + 1`
			done < temp18.txt
rm -rf temp18.txt
echo ""
#-------------------------------------------------------------------------------------------------
echo "	"Alphabetical List of services turned on at run level 3
echo "	-------------------------------------------------------"
chkconfig --list|grep '3:on'|awk -F' ' '{print $1}'|sort > temp15.txt
		ai=1
		while read aj
		do
			echo "	$ai. $aj"
			ai=`expr $ai + 1`
		done < temp15.txt
rm -rf temp15.txt
#-------------------------------------------------------------------------------------------------
echo ""
echo "	User Information"
echo "	---------------"
echo -e "\tTotal Number of Users: `cat /etc/passwd|wc -l`"

u=`grep -E '^[^:]*:[^:]*:0:' /etc/passwd|cut -d':' -f1`
echo -e "\tTotal Number of super users : `echo $u|wc -w` ($u)"

af=`cat /etc/sudoers |grep "ALL=(ALL)"|grep -v '#'|grep -v '%'|sed 's/	/ /g'|tr -s ' '|cut -d' ' -f1`|grep -v 'root'
echo -e "\tList of sudo users : `echo $af|wc -w` ($af)"

ag=`cat /etc/sudoers|grep "ALL=(ALL)"|grep %|grep -v "NOPASSWD"|grep -v "#"|sed 's/	/ /g'|tr -s ' '|cut -d' ' -f1|cut -d'%' -f2`
echo -e "\tList of sudo groups : `echo $ag|wc -w` ($ag)"

find / -user root -perm -4000 -exec ls {} \; &>temp14.txt
echo -e "\tNumber of files with suid bit : `cat temp14.txt|grep -v 'find'|wc -l`"
rm -rf temp14.txt

echo -e "\tPermission of /etc/passwd file: `stat -c '%a' /etc/passwd`"
function perm1
{
ls -l /etc/shadow | cut -d '.' -f1 > a.txt
sed -i 's/-/ /g' a.txt
sed -i 's/rwx/7/g' a.txt
sed -i 's/r x/5/g' a.txt
sed -i 's/rw /6/g' a.txt
sed -i 's/r  /4/g' a.txt
sed -i 's/  x/1/g' a.txt
sed -i 's/   /0/g' a.txt
sed -i 's/ //g' a.txt
a=`cat a.txt`
echo "$a"
rm -rf a.txt
}

echo -e "\tPermission of /etc/shadow file: `perm1 `            "
echo -e "\tUsers without password expiry : `cat /etc/shadow | grep 9999|cut -d ':' -f1|wc -l`"
