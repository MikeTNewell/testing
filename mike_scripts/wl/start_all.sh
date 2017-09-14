#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh
 
if [ ! -d "${TEMPORARY_DIRECTORY}" ]; then
    mkdir -p ${TEMPORARY_DIRECTORY}
fi
 
${WEBLOGIC_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/environment.properties ${SCRIPT_PATH}/start_nodemanager.py
 
#${WEBLOGIC_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/environment.properties ${SCRIPT_PATH}/start_adminsrvr.py

/data/app/oracle/user_projects/domains/base_domain/startWebLogic.sh &
