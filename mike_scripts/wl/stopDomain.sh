#!/bin/bash
######################################################
# NAME: stopDomain.sh
#
# DESC: Stop WLS domain.
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/04/16 cgwong - [v1.0.0] Creation.
######################################################

SCRIPT=`basename $0`
SCRIPT_PATH=$(dirname $SCRIPT)

${SCRIPT_PATH}/stopManagedServers.sh
${SCRIPT_PATH}/stopAdminServer.sh
