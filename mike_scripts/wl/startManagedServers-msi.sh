#!/bin/sh
######################################################
# NAME: startManagedServers-msi.sh
# DESC: Starts WLS Managed Server in independence mode.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/03/19 cgwong - [v1.0.0] Creation.
######################################################

##SCRIPT=$(readlink -f $0)
SCRIPT=`basename $0`
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/WLSenv-run.sh

${WL_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/WLSenv-run.properties ${SCRIPT_PATH}/startManagedServers-msi.py