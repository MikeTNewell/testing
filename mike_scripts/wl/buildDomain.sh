#!/bin/sh
######################################################
# NAME: buildDomain.sh
#
# DESC: Builds a WLS domain based on parameter file values.
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/01/21 cgwong - [v1.0.0] Initial creation.
######################################################

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/WLSenv-dom.sh

# -- Variables -- #
PID=$$
LOGFILE=${LOG_DIR_DEPLOY}/`echo $SCRIPT | awk -F"." '{print $1}'`.log

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

create_deployment_environment() 
{
  ${WL_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/WLSenv-dom.properties ${SCRIPT_PATH}/buildDomain.py
}

pack_domain() 
{
  if [ -f ${SLIB_DIR}/templates/${DOMAIN_NAME}.jar ]; then
    msg pack_domain NOTE 'Removing old template...'
    rm -f ${SLIB_DIR}/templates/${DOMAIN_NAME}.jar
  fi
  msg pack_domain NOTE 'Packing domain...'
  ${WL_HOME}/common/bin/pack.sh -managed=true -domain=${CFG_HOME}/domains/${DOMAIN_NAME} -template=${SLIB_DIR}/templates/${DOMAIN_NAME}.jar -template_name=${DOMAIN_NAME}
}

create_deployment_environment
pack_domain
