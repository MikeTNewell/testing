#!/bin/sh
######################################################
# NAME: startAdminServer.sh
#
# DESC: Starts Admin Server Oracle WebLogic Server (WLS) domain.
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2013/09/12 cgwong - Creation.
# 2014/01/20 cgwong - [v1.0.1] Updated comments and variables.
# 2014/01/21 cgwong - [v1.0.2] Updated environments file name.
# 2014/03/19 cgwong - [v1.0.3] Switched from readlink to basename.
#                     Updated read file names.
######################################################

##SCRIPT=$(readlink -f $0)
SCRIPT=`basename $0`
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/WLSenv-run.sh

${WL_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/WLSenv-run.properties ${SCRIPT_PATH}/startAdminServer.py
