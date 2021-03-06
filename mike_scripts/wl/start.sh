#!/bin/bash
#
#  Copyright 2012 Xebia Nederland B.V.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# NAME
#	weblogic - weblogic service control script
#
# SYNOPSIS
#	weblogic [start|stop|status]
#
# DESCRIPTION
#	This script will start all weblogic servers from installed domains 
#	on this machine. It uses the default startWebLogic.sh and 
#	startManagedWebLogic.sh scripts to avoid the dependencies on the 
#	admin server and the node manager. 
#
# CAVEATS
#	It determines which servers and nodemanagers to boot, by testing the 
#	listen-address of the server and nodemanager configurations in the 
#	config.xml. If it is absent, the script will start an instance on 
#	all machines the domain is copied too. So set the listen-address!
#
#	On the very first boot, it is adviseable to start the admin server 
#	machine first.  On subsequent boots the managed servers will 
#	manage to start without.
#
# COPYRIGHT
# 	Copyright 2012 Xebia Nederland B.V.
#

COMMAND=${1:status}
MW_HOME=${MW_HOME:-/opt/weblogic}
WL_HOME=${WL_HOME:-${MW_HOME}/wlserver}
NODEMANAGER_HOME=$WL_HOME/common/nodemanager
MAXWAIT=12

function allDomains() {
	grep -v '^#' $WL_HOME/common/nodemanager/nodemanager.domains | \
		sed -e 's/^[^=]*=//'
	return 0
}

#
# Set ths domain configuration file for the domain $DOMAIN_HOME.
#
function setDomainConfig() {
		DOMAIN_HOME=$1
		DOMAIN=$(basename $DOMAIN_HOME)
		DOMAIN_CONFIG=$DOMAIN_HOME/config/config.xml
		if [ ! -f $DOMAIN_CONFIG ] ; then
			DOMAIN_CONFIG=$DOMAIN_HOME/config/config_bootstrap.xml
		fi

		if [ ! -f $DOMAIN_CONFIG ] ; then
			echo ERROR: Domain configuration file is missing for domain $DOMAIN >&2
			return 1
		fi
		export DOMAIN_HOME DOMAIN DOMAIN_CONFIG
		return 0
}

#
# Gets the ip address of host $1.
#
function getAddress() {
	echo $(ping -c 1 $1 2>/dev/null | head -1 | awk '{print $3}' | sed -e 's/[()]//g')
}
#
# is address $1 served by this host?
#
function onThisHost() {

	ADDRESS=$(getAddress $1)
	if [ -z "$ADDRESS" ] ; then
		echo "WARN: no address specified for $1 " >&2
		return 0
	fi

	if  expr "$ADDRESS" : '127\.' > /dev/null ; then
		#echo "INFO: $1 is loopback  address " >&2
		return 0
	fi

	PRESENT=$(/sbin/ifconfig | grep -e "addr:$ADDRESS")
        if [ -z "$PRESENT"  ] ; then
		#echo "INFO: $1 is NOT on this host." >&2
		return 1
	else
		#echo "INFO: $1 is on this host. " >&2
		return 0
	fi
}

#
# get the process id of WebLogic Server name $1
#
function getServerPid() {
  PID=$(ps -ef | grep -e "-Dweblogic.Name=$1" | grep -v grep | awk '{print $2}')
  echo $PID
  test -n "$PID" 
}

#
# get the process id of the  node manager machine $1?
#
function getNodeManagerPid() {
  ADDRESS=$(getAddress $2)
  PORT=${3:-5556}
  PID=$(netstat -n -l -p 2>/dev/null | grep -e $ADDRESS:$PORT -e :::$PORT | sed -e  's/.*LISTEN[^0-9]*\([0-9][0-9]*\).*/\1/')
  echo $PID
  test -n "$PID" 
}

#
# start WebLogic Server $1 by calling the appropriate script in the domain.
#
function callStartWebLogic() {
	JAVA_OPTIONS=$(xmlstarlet sel -N d=http://xmlns.oracle.com/weblogic/domain \
			-t -m "/d:domain/d:server[d:name='$1']" \
			-v 'd:server-start/d:arguments' \
			$DOMAIN_CONFIG 2>/dev/null)
	export JAVA_OPTIONS

	ADMINSERVERINFO=$(getAdminServer)
	ADMIN_NAME=$(echo $ADMINSERVERINFO | awk '{print $1}')
	ADMIN_HOST=$(echo $ADMINSERVERINFO | awk '{print $2}')
	ADMIN_PORT=$(echo $ADMINSERVERINFO | awk '{print $3}')
	if [ "$ADMIN_NAME" = "$1" ] ; then
		nohup $DOMAIN_HOME/startWebLogic.sh >/dev/null 2>&1 &
	else
		nohup $DOMAIN_HOME/bin/startManagedWebLogic.sh $1 $ADMIN_HOST:$ADMIN_PORT >/dev/null 2>&1 &
	fi
} 

#
# lists all non admin servers in the domain configuration file.
#
function listAllServers() {
	xmlstarlet sel -N d=http://xmlns.oracle.com/weblogic/domain \
			-t -m "/d:domain/d:server[d:name!=/d:domain/d:admin-server-name]" \
			-v "concat(d:name, ';',  d:listen-address, ';', d:listen-port)" \
			-n \
			$DOMAIN_CONFIG 2>/dev/null   | \
		sed -e '/^[ 	]*$/d' | \
			awk -vhost=$(hostname) -F";" 'BEGIN { port = 7001;  } 
			{ if ($2 == "") $2 = host; 
                          if ($3 == "") $3 = 7001;
			  print $1, $2, $3;
			}' 
}

#
# lists all node managers in the domain configuration file.
#
function listNodeManagers() {
	xmlstarlet sel -N d=http://xmlns.oracle.com/weblogic/domain \
			-t -m "/d:domain/d:machine" \
			-v "concat(d:name, ';',  d:node-manager/d:listen-address, ';', d:node-manager/d:listen-port)" \
			-n \
			$DOMAIN_CONFIG 2>/dev/null   | \
		sed -e '/^[ 	]*$/d' | \
			awk -vhost=$(hostname) -F";" \
			'{ if ($2 == "") $2 = host; 
                          if ($4 == "") $3 = 5556;
			  print $1, $2, $3;
			}' 
}

#
# Check that all servers have an explicit listen-address specification in the domain configuration file.
#
function checkExplicitListenAddress() {
	xmlstarlet sel -N d=http://xmlns.oracle.com/weblogic/domain \
			-t -m "/d:domain/d:server" \
			-v "concat(d:name, ';',  d:listen-address)" \
			-n \
			$DOMAIN_CONFIG 2>/dev/null | \
			awk -F";" -vdomain=$DOMAIN \
			'
			{ if ($1 != "" && $2 == "") { 
				print "WARN: The server " $1 " of domain " domain " does not have an explicit listen address and will start on any server." > "/dev/stderr" 
			  }
			}' 
}

#
# gets the admin server from the domain configuration file. 
#
function getAdminServer() {
	xmlstarlet sel -N d=http://xmlns.oracle.com/weblogic/domain \
			-t -m "/d:domain/d:server[d:name=/d:domain/d:admin-server-name]" \
			-v "concat(d:name, ';',  d:listen-address, ';', d:listen-port)" \
			-n \
			$DOMAIN_CONFIG 2>/dev/null | \
			sed -e '/^$/d' | \
			awk -vhost=$(hostname) -F";" \
			'
			{ if ($2 == "") $2 = host; 
                          if ($3 == "") $3 = 7001;
			  print $1, $2, $3;
			}' 
}

#
# Start the server if it is not already running.
#
function startServer() {

  if onThisHost $2 ; then
	if listenerOnPort $2 ${3:-7001} ; then
		echo "INFO: Server $1 of domain $DOMAIN is already running." 
	else
		echo -n "INFO: starting $1 of domain $DOMAIN" 
		callStartWebLogic $@
		COUNT=0
		ISRUNNING=1
		while [ $ISRUNNING -ne 0 -a $COUNT -lt $MAXWAIT ] ; do
			sleep 10; echo -n .
			listenerOnPort $2 ${3:-7001}
			ISRUNNING=$?
			COUNT=$(($COUNT +1))
		done
		echo
		if [ $ISRUNNING -eq 1 ] ; then
			PID=$(getServerPid $1)
			if [ -z "$PID" ] ; then
				echo "ERROR: failed to start server $2 of domain $DOMAIN" 2>&1
				return 1
			else
				echo "WARN: server $2 of domain $DOMAIN started but not yet listening on ${3:7001}." 2>&1
				return 2
			fi
		fi
	fi
  fi
}

#
# Stops the server if it is running.
#
function stopServer() {

  if onThisHost $2 ; then
	PID=$(getServerPid $1)
	if test -n "$PID" && listenerOnPort $2 ${3:-7001} ; then
		echo -n "INFO: stopping $1 of domain $DOMAIN" 
		kill -15 $PID
		COUNT=0
		ISRUNNING=0
		while [ $ISRUNNING -eq 0 -a $COUNT -lt $MAXWAIT ] ; do
			sleep 10; echo -n .
			listenerOnPort $2 ${3:-7001}
			ISRUNNING=$?
			COUNT=$(($COUNT + 1))
		done
		echo
		if [ $ISRUNNING -eq 0 ] ; then
			echo "ERROR: failed to stop server $2 of domain $DOMAIN. " 2>&1
			return 1
		else
			echo "INFO: Server $1 of domain $DOMAIN is stopped." 
		fi
	else
		echo "INFO: Server $1 of domain $DOMAIN is already stopped." 
	fi
  fi
  return 0
}


#
# tests if there is a listener on port $2 of  network address $1
#
function listenerOnPort() {
		ADDRESS=$(getAddress $1)
		LISTENING=$(netstat -a -n | \
				egrep -e "$ADDRESS:$2[ 	].*LISTEN" -e ":::$2[ 	].*LISTEN" )
		test -n "$LISTENING"
		return $?
}

#
# stop the node manager if it is running.
function stopNodeManager() {

 if onThisHost $2 ; then
	PID=$(getNodeManagerPid $@)
	if test -n "$PID" &&  listenerOnPort $2 ${3:-5556} ; then
		echo -n "INFO: stopping nodemanager $1" 
		kill -15 $PID
		COUNT=0
		ISRUNNING=0
		while [ -n "$PID" -a $ISRUNNING -eq 0 -a $COUNT -lt $MAXWAIT ] ; do
			sleep 10; echo -n .
			listenerOnPort $2 ${3:-5556}
			ISRUNNING=$?
			COUNT=$(($COUNT + 1))
		done
		echo
		if [ $ISRUNNING -eq 0 ] ; then
			echo "ERROR: failed to stop nodemanager $1. " 2>&1
			return 1
		else
			echo "INFO: Nodemanager $1 is stopped." 
		fi
	else
		echo "INFO: NodeManager $1 is already stopped." 
	fi
  fi
  return 0
}

#
# output the status of the server 
#
function statusServer() {

  if onThisHost $2 ; then
	if listenerOnPort $2 ${3:-7001}; then
		PID=$(getServerPid $1)
		if [ -n "$PID" ] ; then
			echo "INFO: Server $1 of domain $DOMAIN is running on port ${3:-7001} process id $PID." 
		else
			echo "INFO: Server $1 of domain $DOMAIN port ${3:-7001} is in use, but there is no process." 
		fi
	else
		echo "INFO: Server $1 of domain $DOMAIN is not running." 
	fi
  fi
}

#
# Output the status of the node manager.
#
function statusNodeManager() {

  if onThisHost $2 ; then
	if listenerOnPort $2 ${3:-5556}; then
		PID=$(getNodeManagerPid $@)
		if [ -n "$PID" ] ; then
			echo "INFO: NodeManager $1 is running on port ${3:-5556} process id $PID." 
		else
			echo "WARN: NodeManager $1 port ${3:-5556} is in use, but there is no process." 
		fi
	else
		echo "INFO: NodeManager $1 is not running." 
	fi
  fi
}

#
# Start the node manager if on this host and it is not running.
#
function startNodeManager() {

  if onThisHost $2 ; then
	if listenerOnPort $2 ${3:-5556}; then
		echo "INFO: NodeManager $1 is already running." 
	else
		echo -n "INFO: starting $1" 
		nohup $WL_HOME/server/bin/startNodeManager.sh  >/dev/null  2>&1 &
		COUNT=0
		ISRUNNING=1
		while [ $ISRUNNING -ne 0 -a $COUNT -lt $MAXWAIT ] ; do
			sleep 3; echo -n .
			listenerOnPort $2 ${3:-5556}
			ISRUNNING=$?
			COUNT=$(($COUNT + 1))
		done
		echo
		if [ $ISRUNNING -eq 1 ] ; then
			echo "ERROR: failed to start node manager $2" 2>&1
			return 1
		fi
		
	fi
  fi
}

#
# stop all managed servers.
#
function stopAllServers() {
	result=0
	listAllServers | \
	while read LINE ; do
		stopServer $LINE
		[ $? -ne 0 ] && result=1
	done
	return $result
}

#
# report the status of all servers.
#
function statusAllServers() {
	result=0
	listAllServers | \
	while read LINE ; do
		statusServer $LINE
		[ $? -ne 0 ] && result=1
	done
	return $result
}

#
# copy the boot.properties of the admin server to the managed servers if it is missing.
#
function copyBootProperties() {
	result=0
	ADMIN=$(getAdminServer | awk '{print $1}')
	SOURCE=$DOMAIN_HOME/servers/$ADMIN/security/boot.properties
	if [ -f $SOURCE ] ; then
		listAllServers | \
		while read LINE ; do
			set $LINE
			SERVER=$1
			if onThisHost $2 ; then
			    TARGETDIR=$DOMAIN_HOME/servers/$SERVER/security
			    if [ ! -f $TARGETDIR/boot.properties ] ; then
				mkdir -p $TARGETDIR
				cp -f $SOURCE $TARGETDIR
				[ $? -ne 0 ] && result=1
				echo "INFO: copied boot.properties to $SERVER" >&2
			    fi
			fi
		done
	else
		echo "ERROR: No boot.properties found for the admin server to copy. "
		result=1
	fi
	return $result
}

#
# start all managed servers.
#
function startAllServers() {
	result=0
	listAllServers | \
	while read LINE ; do
		startServer $LINE
		[ $? -ne 0 ] && result=1
	done
	return $result
}


# 
# report the status of all node managers
#
function statusAllNodeManagers() {
	result=0
	listNodeManagers | \
	while read LINE ; do
		statusNodeManager $LINE
		[ $? -ne 0 ] && result=1
	done
	return $result
}

# 
# start all node managers.
#
function startAllNodeManagers() {
	result=0
	listNodeManagers | \
	while read LINE ; do
		startNodeManager $LINE
		[ $? -ne 0 ] && result=1
	done
	return $result
}

# 
# stop all the node managers.
#
function stopAllNodeManagers() {
	result=0
	listNodeManagers | \
	while read LINE ; do
		stopNodeManager $LINE
		[ $? -ne 0 ] && result=1
	done
	return $result
}

#
# Test the pre-conditions
#
xmlStarletXists=$(which xmlstarlet 2> /dev/null)
if [ -z "$xmlStarletXists" ]; then
	echo "ERROR: I am useless without an installation of xmlstarlet! Please install" >&2
	exit 1;
fi

if [ ! -d $WL_HOME -a ! -d $NODEMANAGER_HOME ] ; then
	echo "ERROR: It does not appear as if WL_HOME is pointing to a WebLogic Server installation directory." >&2
	exit 1;
fi

function stopDomain() {
	stopAllServers
	stopServer $(getAdminServer)
	stopAllNodeManagers
}

function statusDomain() {
	checkExplicitListenAddress
	statusAllNodeManagers
	statusServer $(getAdminServer)
	statusAllServers
}

function startDomain() {
	checkExplicitListenAddress
	startAllNodeManagers
	startServer $(getAdminServer)
	copyBootProperties
	startAllServers
}

if [ "$COMMAND" = "stop" ] ; then

	for domain in $(allDomains) ; do
		if setDomainConfig $domain; then
			stopDomain
		fi
	done
fi

if [ "$COMMAND" = "status" ] ; then

	for domain in $(allDomains) ; do
		if setDomainConfig $domain ; then
			statusDomain
		fi
	done
fi


if [ "$COMMAND" = "start" ]; then
	for domain in $(allDomains) ; do
		if setDomainConfig $domain ; then
			startDomain
		fi
	done
fi

