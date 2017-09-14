#!/bin/sh
######################################################
# NAME: createDomain.sh
#
# DESC: Creates a WLS domain based on parameter file values.
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/01/31 cgwong - [v1.0.0] Rebuild file.
# 2014/02/17 cgwong - [v1.0.1] Use basename instead of readlink.
# 2014/03/20 cgwong - [v1.0.1] Updated setup script name and some variable names.
######################################################

SCRIPT=`basename $0`
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/WLSenv-dom.sh

# -- Variables -- #
PID=$$
LOGFILE=${LOG_DIR}/`echo $SCRIPT | awk -F"." '{print $1}'`.log

# -- Functions -- #
msg ()
{ # Print message to screen and log file
  # Valid parameters:
  #   $1 - function name
  #   $2 - Message Type or status
  #   $3 - message
  #
  # Log format:
  #   Timestamp: [yyyy-mm-dd hh24:mi:ss]
  #   Component ID: [compID: ]
  #   Process ID (PID): [pid: ]
  #   Host ID: [hostID: ]
  #   User ID: [userID: ]
  #   Message Type: [NOTE | WARN | ERROR | INFO | DEBUG]
  #   Message Text: "Metadata Services: Metadata archive (MAR) not found."

  # Variables
  TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
  [[ -n $LOGFILE ]] && echo -e "[${TIMESTAMP}],PRC: ${1},PID: ${PID},HOST: $TGT_HOST,USER: ${USER}, STATUS: ${2}, MSG: ${3}" | tee -a $LOGFILE
}

create_basic_domain() 
{
	${WL_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/WLSenv-dom.properties ${SCRIPT_PATH}/createDomain.py
  
  msg create_basic_domain INFO "Copying demo Keystore."
	mkdir -p ${CFG_BASE}/domains/${DOMAIN_NAME}/nodemanager/security
	cp ${CFG_BASE}/domains/${DOMAIN_NAME}/security/DemoIdentity.jks ${CFG_BASE}/domains/${DOMAIN_NAME}/nodemanager/security
}

change_memory_settings_using_overridefile() 
{
# Creates/modifies setUserOverrides.sh file with the following:
#
#ADMIN_SERVER_MEM_ARGS="-Xms512m -Xmx512m -XX:PermSize=256m -XX:MaxPermSize=256m"
#SERVER_MEM_ARGS="-Xms512m -Xmx512m -XX:PermSize=256m -XX:MaxPermSize=256m"
#COHERENCE_SERVER_MEM_ARGS="-Xms512m -Xmx512m -XX:PermSize=256m -XX:MaxPermSize=256m"
#COHERENCE_MONITORING_ARGS="-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true"
#GARBAGE_COLLECTOR_ARGS="-XX:NewRatio=3 -XX:SurvivorRatio=128 -XX:MaxTenuringThreshold=0 -XX:+UseParallelGC -XX:MaxGCPauseMillis=200 -XX:GCTimeRatio=19 -XX:+UseParallelOldGC -XX:+UseTLAB"
#LARGE_PAGES_ARGS="-XX:LargePageSizeInBytes=2048k -XX:+UseLargePages"
#
#if [ "${ADMIN_URL}" = "" ] ; then
#	USER_MEM_ARGS="${ADMIN_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"
#else
#	case ${SERVER_NAME} in
#		server_*)
#			USER_MEM_ARGS="${SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${LARGE_PAGES_ARGS}"
#		;;
#		coherence_server_1)
#			USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${LARGE_PAGES_ARGS} ${COHERENCE_MONITORING_ARGS}"
#		;;
#		coherence_server_*)
#			USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${LARGE_PAGES_ARGS}"
#		;;
#	esac
#fi
#export USER_MEM_ARGS
#
# The Xms and Xms parameters are configurable by using the ASRV_HEAP_SZ, MSRV_HEAP_SZ, and
# CSRV_HEAP_SZ variables.

	msg change_memory_settings_using_overridefile NOTE "Changing Derby flag in ${CFG_BASE}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh"
	sed -i -e '/DERBY_FLAG="true"/ s:DERBY_FLAG="true":DERBY_FLAG="false":' ${CFG_BASE}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh

	msg change_memory_settings_using_overridefile NOTE "Changing memory settings in ${CFG_BASE}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh"
	touch ${CFG_BASE}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh
	chmod u+x ${CFG_BASE}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh

	echo '#!/bin/sh

ADMIN_SERVER_MEM_ARGS="-Xms'${ASRV_HEAP_SZ}' -Xmx'${ASRV_HEAP_SZ}' -XX:PermSize='${ASRV_PERM_SZ}' -XX:MaxPermSize='${ASRV_PERM_SZ}'"
SERVER_MEM_ARGS="-Xms'${MSRV_HEAP_SZ}' -Xmx'${MSRV_HEAP_SZ}' -XX:PermSize='${MSRV_PERM_SZ}' -XX:MaxPermSize='${MSRV_PERM_SZ}'"
COHERENCE_SERVER_MEM_ARGS="-Xms'${CSRV_HEAP_SZ}' -Xmx'${CSRV_HEAP_SZ}' -XX:PermSize='${CSRV_PERM_SZ}' -XX:MaxPermSize='${CSRV_PERM_SZ}'"
MONITORING_ARGS="-XX:+UnlockCommercialFeatures -XX:+FlightRecorder"
COHERENCE_MONITORING_ARGS="-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true"
GARBAGE_COLLECTOR_ARGS="-XX:NewRatio=3 -XX:SurvivorRatio=128 -XX:MaxTenuringThreshold=0 -XX:+UseParallelGC -XX:MaxGCPauseMillis=200 -XX:GCTimeRatio=19 -XX:+UseParallelOldGC -XX:+UseTLAB"
LARGE_PAGES_ARGS="-XX:LargePageSizeInBytes=1024m -XX:+UseLargePages"

if [ "${ADMIN_URL}" = "" ] ; then
	USER_MEM_ARGS="${ADMIN_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"
else
	case ${SERVER_NAME} in
		*coh_msrv_8001)   # First Coherence Managed Server is also JMX monitoring node
			USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${COHERENCE_MONITORING_ARGS}"
		;;
		*coh_msrv_*)      # All other Coherence Managed Servers 
			USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"
		;;
		*_msrv_*)         # Pretty much any other non-Coherence Managed Servers
			USER_MEM_ARGS="${SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${MONITORING_ARGS}"
		;;
	esac
fi
export USER_MEM_ARGS

#if [ "${WEBLOGIC_EXTENSION_DIRS}" != "" ] ; then
#	WEBLOGIC_EXTENSION_DIRS="${WEBLOGIC_EXTENSION_DIRS}${CLASSPATHSEP}${DOMAIN_HOME}/lib"
#else
#	WEBLOGIC_EXTENSION_DIRS="${DOMAIN_HOME}/lib"
#fi
#export WEBLOGIC_EXTENSION_DIRS' > ${CFG_BASE}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh
}

create_basic_domain
change_memory_settings_using_overridefile
