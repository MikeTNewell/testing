#!/bin/sh
######################################################
# NAME: expandDomain.sh
#
# DESC: Expands a WLS domain based on parameter file values.
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/04/16 cgwong - [v1.0.0] Initial creation.
######################################################

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/WLSenv-dom.sh

unpack_domain() 
{
  ${WL_HOME}/common/bin/unpack.sh -domain=${CFG_HOME}/domains/${DOMAIN_NAME} -template=${SLIB_DIR}/templates/${DOMAIN_NAME}.jar
}

expand_domain() 
{
  ${WL_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/WLSenv-dom.properties ${SCRIPT_PATH}/expandDomain.py

  mkdir -p ${CFG_HOME}/domains/${DOMAIN_NAME}/nodemanager/security
  cp ${CFG_HOME}/domains/${DOMAIN_NAME}/security/DemoIdentity.jks ${CFG_HOME}/domains/${DOMAIN_NAME}/nodemanager/security
}

change_memory_settings() 
{
# Change memory settings alters the setDomainEnv file and adds the following
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
# The Xms and Xms parameters are configurable by using the ADMIN_SERVER_HEAP_SIZE, MANAGED_SERVER_HEAP_SIZE, and
# COHERENCE_SERVER_HEAP_SIZE variables.
  echo 'CHANGE MEMORY SETTINGS'

  ADMIN_SERVER_HEAP_SIZE=512m
  MANAGED_SERVER_HEAP_SIZE=512m
  COHERENCE_SERVER_HEAP_SIZE=512m	

  sed -i.bak -e '/export WL_HOME/ a\\nADMIN_SERVER_MEM_ARGS="-Xms'${ADMIN_SERVER_HEAP_SIZE}' -Xmx'${ADMIN_SERVER_HEAP_SIZE}' -XX:PermSize=256m -XX:MaxPermSize=256m"\nSERVER_MEM_ARGS="-Xms'${MANAGED_SERVER_HEAP_SIZE}' -Xmx'${MANAGED_SERVER_HEAP_SIZE}' -XX:PermSize=256m -XX:MaxPermSize=256m"\nCOHERENCE_SERVER_MEM_ARGS="-Xms'${COHERENCE_SERVER_HEAP_SIZE}' -Xmx'${COHERENCE_SERVER_HEAP_SIZE}' -XX:PermSize=256m -XX:MaxPermSize=256m"\nCOHERENCE_MONITORING_ARGS="-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true"\nGARBAGE_COLLECTOR_ARGS="-XX:NewRatio=3 -XX:SurvivorRatio=128 -XX:MaxTenuringThreshold=0 -XX:+UseParallelGC -XX:MaxGCPauseMillis=200 -XX:GCTimeRatio=19 -XX:+UseParallelOldGC -XX:+UseTLAB"\nLARGE_PAGES_ARGS="-XX:LargePageSizeInBytes=2048k -XX:+UseLargePages"\n\nif [ "${ADMIN_URL}" = "" ] ; then\n	USER_MEM_ARGS="${ADMIN_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"\nelse\n	case ${SERVER_NAME} in\n		server_*)\n			USER_MEM_ARGS="${SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${LARGE_PAGES_ARGS}"\n		;;\n		coherence_server_1)\n			USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${LARGE_PAGES_ARGS} ${COHERENCE_MONITORING_ARGS}"\n		;;\n		coherence_server_*)\n			USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${LARGE_PAGES_ARGS}"\n		;;\n	esac\nfi\nexport USER_MEM_ARGS' \
 -e '/DERBY_FLAG="true"/ s:DERBY_FLAG="true":DERBY_FLAG="false":' ${CFG_HOME}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh
}

unpack_domain
expand_domain
change_memory_settings
