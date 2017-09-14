#!/bin/bash
######################################################
# NAME: WLSinst-12c.sh
#
# DESC: Installs Oracle WebLogic Server (WLS) 12c software.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2013/09/12 cgwong - [v1.0.0] Creation.
# 2014/01/18 cgwong - [v1.1.0] Added logging functionality.
#                   - Updated variables, added central inventory function
# 2014/01/21 cgwong - [v1.1.1] Updated LOGFILE variable.
# 2014/02/09 cgwong - [v1.2.0] Added WLS patching.
#                     Added script name in header comments.
# 2014/02/17 cgwong - [v1.2.1] Used basename instead of readlink
# 2014/03/19 cgwong - [v2.0.0] Added functionality for WLS 10.3.5
#                     Added functionality for JRockit
#                     Used Java entropy fix in security module
#                     Switched to external response file edits.
# 2014/03/20 cgwong - [v2.1.0] Reduced functionality to WLS 12c specifically.
# 2014/03/21 cgwong - [v2.2.0] Added exit status.
#                     Added checks for file/directory existence.
#                     Switched to double ticks for messages.
#                     Other improvements (command line parameter) and bug fixes.
# 2014/03/24 cgwong - [v2.3.0] Updated patching to use OPatch instead of Smart UpPdate.
#                     Various bug fixes.
# 2014/03/25 cgwong - [v2.3.1] Removed inventory update (process does not exist).
#                     Updated directory empty checks.
# 2014/04/17 cgwong: [v2.3.2] Various minor code improvements.
# 2014/05/07 cgwong: [v2.3.3] Updated patching variables. 
######################################################

SCRIPT=`basename $0`
SCRIPT_PATH=$(dirname $SCRIPT)
SETUP_FILE=${SCRIPT_PATH}/WLSenv-inst.sh

##. ${SETUP_FILE}

# -- Variables -- #
PID=$$
SKIP_JDK="N"
ERR=1     # Error status
SUC=0     # Success status

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
  [[ -n $LOGFILE ]] && echo -e "[${TIMESTAMP}],PRC: ${1},PID: ${PID},HOST: ${TGT_HOST},USER: ${USER}, STATUS: ${2}, MSG: ${3}" | tee -a $LOGFILE
}

show_usage ()
{ # Show script usage
  echo "
 ${SCRIPT} - Linux shell script to install Oracle JDK and WebLogic Server (WLS) 12c software.
  The following steps are done:
  
  1. Install the specified Oracle JDK release (optional)
  2. Install the specified WLS 12c software release
  3. Apply any patches as specified to the WLS installation
  
  The default environment setup file, ${SETUP_FILE}, is assumed to be in the same directory
  as this script. The -f parameter can be used to specify another file or location. Patches
  should be in the regular zipped naming format in order to be applied. See below for the 
  full script usage and options.

 USAGE
 ${SCRIPT} [OPTION]
 
 OPTIONS
  -f [path/file]
    Full path and file name for environment setup file to be used.

  -nojdk
    Flag to skip an Oracle JDK installation (for when one already exists on the server).
    
  -h
    Display this help screen.    
"
}

create_silent_install_files() 
{ # Create/setup installation response files
  if [ -f "${WL_RSP_FILE}" ]; then
    msg create_silent_install_file INFO "Creating silent install files..."
    sed "/ORACLE_HOME=/c\ORACLE_HOME=${MW_HOME}" ${WL_RSP_FILE} > ${STG_DIR}/`basename ${WL_RSP_FILE}`
    WL_RSP_FILE=${STG_DIR}/`basename ${WL_RSP_FILE}`    # Reset variable to new value for easier referencing in script
  else
    msg create_silent_install_file ERROR "Missing silent install file: ${WL_RSP_FILE}"
    exit $ERR
  fi
  
  # Process inventory file
  if [ ! -f "${ORAINV_PTR_FILE}" ]; then
    msg create_silent_install_files INFO "Creating temporary Oracle Inventory file..."
    echo "inventory_loc=${ORAINV_HOME}" > ${STG_DIR}/`basename ${ORAINV_PTR_FILE}`
    echo "inst_group=${OINST_GRP}"     >> ${STG_DIR}/`basename ${ORAINV_PTR_FILE}`
    ORAINV_PTR_FILE=${STG_DIR}/`basename ${ORAINV_PTR_FILE}`
    msg create_silent_install_files NOTE "Ensure ${ORAINV_PTR_FILE} is put under /etc and owned by root with permissions 770."
  else
    msg create_silent_install_files NOTE "Oracle Inventory file ${ORAINV_PTR_FILE} exists."
    msg create_silent_install_files INFO "\n`cat ${ORAINV_PTR_FILE}`"
  fi
}

install_jdk() 
{ # Install Oracle JDK
  # Create ORACLE_BASE directory if it does not exist
  if [ ! -d "${ORACLE_BASE}" ]; then
    msg install_jdk INFO "Creating directory: ${ORACLE_BASE}."
    mkdir -p ${ORACLE_BASE}
  fi

  # Check for existence of files and directories
  if [ ! -f "$JVM_FILE" ]; then
    msg install_jdk ERROR "Missing JVM file: ${JVM_FILE}."
    exit $ERR
  fi
  if [ -d ${JVM_HOME} ]; then
    msg install_jdk WARN "${JVM_HOME} already exists."
    return 
  fi
  if [ -d ${JAVA_HOME} ]; then
    msg install_jdk WARN "${JAVA_HOME} already exists."
    return 
  fi
  
  msg install_jdk INFO "Installing Oracle JDK..."
  tar xzf ${JVM_FILE} -C ${STG_DIR}
  mkdir -p ${JVM_HOME}
  mv ${STG_DIR}/${JDK_DEFAULT_NAME}/* ${JVM_HOME}/
  rmdir ${STG_DIR}/${JDK_DEFAULT_NAME}
  
  # Create a link having the full version designation as a reference
  # to the real generic named version. This allows for easier future JDK upgrades.
  # WLS installation resolves links hence why this method.
  mv ${JVM_HOME} ${JAVA_HOME}/
  ln -s ${JAVA_HOME} ${JVM_HOME}
  
  # Adjust Java entropy value to avoid performance bug with Linux
  msg install_jdk INFO "Adjusting entropy gathering device settings..."
  sed '/securerandom/ s_file:/dev/urandom_file:/dev/./urandom_' ${JAVA_HOME}/jre/lib/security/java.security > ${STG_DIR}/java.security
  mv ${STG_DIR}/java.security ${JAVA_HOME}/jre/lib/security/java.security
}

install_wls() 
{ # Install WLS software
  if [ ! -f "${WL_FILE}" ]; then   # Check for existence of file
    msg install_wls ERROR "Missing file: ${WL_FILE}, unable to install WLS."
    exit $ERR
  fi
  if [ ! -f "${WL_RSP_FILE}" ]; then   # Check for existence of file
    msg install_wls ERROR "Missing file: ${WL_RSP_FILE}, unable to install WLS."
    exit $ERR
  fi
  msg install_wls INFO "Installing WebLogic Server..."
  if [ -f ${JAVA_HOME}/bin/java ]; then
    if [ `ls ${MW_HOME}/* 2>/dev/null | wc -l` -gt 0 ]; then
      msg install_wls ERROR "Non-empty ${MW_HOME} directory. Directory must be empty for installation."
      exit $ERR
    fi
    ${JAVA_HOME}/bin/java -d64 -Xms512m -Xmx512m -jar ${WL_FILE} -silent -response ${WL_RSP_FILE} -invPtrLoc ${ORAINV_PTR_FILE}
  else
    msg install_wls ERROR "Missing java binary in ${JAVA_HOME}/bin"
    exit $ERR
  fi
}

patch_wls ()
{ # Apply patches to WLS
  # Patch bundle cache directory
  PB_CACHE_DIR=${STG_DIR}/cache_dir
  
  if [ `ls ${PB_DIR}/*.zip 2>/dev/null | wc -l` -gt 0 ]; then   # Not empty directory
    msg patch_wls INFO "Applying patch bundle ${PB} to WLS..."
    # Apply latest OPatch first
    if [ `ls ${PB_DIR}/p6880880*.zip 2>/dev/null | wc -l` -gt 0 ]; then   # File exists
      msg patch_wls INFO "Applying latest OPatch in repository to ${MW_HOME}."
      unzip -oq ${PB_DIR}/p6880880*.zip -d ${MW_HOME}
    fi
    
    # Apply other patches
    if [ ! -d ${PB_CACHE_DIR} ]; then
      msg patch_wls INFO "Creating cache dir: ${PB_CACHE_DIR}"
      mkdir -p ${PB_CACHE_DIR}
    fi

    # Save current directory and apply patches in turn (apply) instead of in bulk (napply)
    CURR_DIR=${PWD}
    msg patch_wls INFO "Applying WLS patches in repository."
    if [ ! -f ${OCM_RSP_FILE} ]; then # Check for OCM response file
      msg patch_wls WARN "Missing OCM response file ${OCM_RSP_FILE}. Patching will be interactive."
      OCMRSP=""
    else
      OCMRSP="-ocmrf ${OCM_RSP_FILE}"
    fi
    for fname in `ls -1 ${PB_DIR}/p1*.zip 2>/dev/null`; do
      unzip -oq ${fname} -d ${PB_CACHE_DIR}
      patchname=`basename ${fname} | cut -d 'p' -f2 | cut -d '_' -f1`
      cd ${PB_CACHE_DIR}/${patchname}
      ${MW_HOME}/OPatch/opatch apply -silent -oh ${MW_HOME} ${OCMRSP}
    done
    
    cd ${CURR_DIR}    # Return to original directory
    msg patch_wls INFO "Cleaning up cache dir: ${PB_CACHE_DIR}"
    rm -rf ${PB_CACHE_DIR}
  else    # Empty directory
    msg patch_wls INFO "No zipped patches found to apply in ${PB_DIR}."
  fi
}


# -- Main Code -- #
# Process command line
while [ $# -gt 0 ] ; do
  case $1 in
  -f)   # Different setup file
    SETUP_FILE=$2
    if [ -z "$SETUP_FILE" ] || [ ! -f "$SETUP_FILE" ]; then
      echo "ERROR: Invalid -f option."
      show_usage
      exit $ERR
    fi
    shift ;;
  -nojdk)   # Skip JDK installation
    SKIP_JDK="Y"
    shift ;;
  -h)   # Print help and exit
    show_usage
    exit $SUC ;;
  *)   # Print help and exit
    show_usage
    exit $ERR ;;
  esac
  shift
done

# Setup environment
. ${SETUP_FILE}

LOGFILE=${LOG_DIR}/`echo ${SCRIPT} | awk -F"." '{print $1}'`.log

# Setup staging
RUN_DT=`date "+%Y%m%d-%H%M%S"`
STG_DIR=${STG_DIR}/install-${RUN_DT} 
[ ! -d "${STG_DIR}" ] && mkdir -p ${STG_DIR}

create_silent_install_files
[ "${SKIP_JDK}" == "N" ] && install_jdk
install_wls
patch_wls

# END