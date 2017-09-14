#!/bin/sh
######################################################
# NAME: startNodeManager.sh
#
# DESC: Starts Node Manager for Oracle WebLogic Server (WLS) domain.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2013/09/12 cgwong - [v1.0.0] Creation.
# 2014/01/17 cgwong - [v1.0.1] Updated comments.
#                   - Updated dependent file locations.
# 2014/01/21 cgwong - [v1.0.2] Updated environments file name.
# 2014/03/19 cgwong - [v1.0.3] Updated name of called environment files.
######################################################

SCRIPT=`basename $0`
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/WLSenv-run.sh

${WL_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/WLSenv-run.properties ${SCRIPT_PATH}/startNodeManager.py
