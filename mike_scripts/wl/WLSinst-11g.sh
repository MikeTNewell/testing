#!/bin/bash
######################################################
# NAME: WLSinst.sh
#
# DESC: Installs Oracle WebLogic Server (WLS) 10.3.5 software.
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
# 2014/03/20 cgwong - [v2.1.0] Reduced functionality to WLS 11g specifically.
# 2014/03/21 cgwong - [v2.2.0] Added exit status.
#                     Added checks for file/directory existence.
#                     Switched to double ticks for messages.
#                     Removed inventory update.
#                     Other improvements (command line parameter) and bug fixes.
# 2014/03/24 cgwong - [v2.2.1] Updated patching variables.
# 2014/03/25 cgwong - [v2.3.1] Updated directory empty check.
#                     Included response file update.
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
 ${SCRIPT} - Linux shell script to install Oracle JRockit and WebLogic Server (WLS) 11g software.
  Specifically, the following steps are done:
  
  1. Install the specified Oracle JRockit release (optional)
  2. Install the specified WLS 11g software release
  3. Apply any patches as specified to the WLS installation
  
  The default environment setup file, ${SETUP_FILE}, is assumed to be in the same directory
  as this script. The -f parameter can be used to specify another file or location. Patches
  should be in the regular zipped naming format in order to be applied. See below for the 
  full script usage and options.

 USAGE
 ${SCRIPT} [OPTION]
 
 OPTIONS
  -f [path/file]
    Full path and file name for environment setup file to be used. The default is: ${SETUP_FILE}
  
  -nojdk
    Flag to skip an Oracle JDK installation (for when one already exists on the server).
    
  -h
    Display this help screen.    
"
}

create_silent_install_files() 
{ # Create/setup installation response files
  # Setup JRockit response file
  if [ -f "${JVM_RSP_FILE}" ]; then
    msg create_silent_install_file INFO "Creating JVM silent install file..."
    sed "/USER_INSTALL_DIR/c\    <data-value name=\"USER_INSTALL_DIR\" value=\"${JAVA_HOME}\" />" ${JVM_RSP_FILE} > ${STG_DIR}/`basename ${JVM_RSP_FILE}`
    JVM_RSP_FILE=${STG_DIR}/`basename ${JVM_RSP_FILE}`    # Reset variable to new value for easier referencing in script
  else
    msg create_silent_install_file ERROR "Missing silent install file: ${JVM_RSP_FILE}"
    exit $ERR
  fi

  # Setup BSU response file
  if [ -f "${BSU_RSP_FILE}" ]; then
    msg create_silent_install_file INFO "Creating BSU silent install file..."
    sed "/BEAHOME/c\    <data-value name=\"BEAHOME\" value=\"${MW_HOME}\" />" ${BSU_RSP_FILE} > ${STG_DIR}/`basename ${BSU_RSP_FILE}`
    BSU_RSP_FILE=${STG_DIR}/`basename ${BSU_RSP_FILE}`    # Reset variable to new value for easier referencing in script
  else
    msg create_silent_install_file ERROR "Missing silent install file: ${BSU_RSP_FILE}"
    exit $ERR
  fi
  
  # Setup WLS response file
  if [ -f "${WL_RSP_FILE}" ]; then
    msg create_silent_install_file INFO "Creating WLS silent install file..."
    cat ${WL_RSP_FILE} | sed "/BEAHOME/c\    <data-value name=\"BEAHOME\" value=\"${MW_HOME}\" />" | sed "/WLS_INSTALL_DIR/c\    <data-value name=\"WLS_INSTALL_DIR\" value=\"${WL_HOME}\" />" | sed "/LOCAL_JVMS/c\    <data-value name=\"LOCAL_JVMS\" value=\"${JAVA_HOME}\" />" > ${STG_DIR}/`basename ${WL_RSP_FILE}`
    WL_RSP_FILE=${STG_DIR}/`basename ${WL_RSP_FILE}`    # Reset variable to new value for easier referencing in script
  else
    msg create_silent_install_file ERROR "Missing silent install file: ${WL_RSP_FILE}"
    exit $ERR
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
    msg install_jdk ERROR "${JVM_HOME} already exists."
    return 
  fi
  if [ -d ${JAVA_HOME} ]; then
    msg install_jdk ERROR "${JAVA_HOME} already exists."
    return 
  fi

  msg install_jdk INFO "Installing Oracle JRockit..."
  ${JVM_FILE} -mode=silent -silent_xml=${JVM_RSP_FILE}

  # Create a link having the full version designation as a reference
  # to the real generic named version. This allows for easier future JDK upgrades.
  # WLS installation resolves links hence why this method.
  #mv ${JVM_HOME} ${JAVA_HOME}/
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
    ${JAVA_HOME}/bin/java -d64 -Xms512m -Xmx512m -jar ${WL_FILE} -mode=silent -silent_xml=${WL_RSP_FILE}
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

    # Apply Updated BSU (Smart Update) first
    # This is ONLY required for WLS 10.3.5 so it can apply latest patches. The file MUST be manually renamed correctly
    # as we are expecting it to match a certain format such that the filtering works
    if [ `ls ${PB_DIR}/p*Generic-bsu.zip 2>/dev/null | wc -l` -gt 0 ]; then
      [ ! -d ${PB_CACHE_DIR} ] && mkdir -p ${PB_CACHE_DIR}    # Create BSU cache directory if it does not exist
      unzip -oq ${PB_DIR}/p*-bsu.zip -d ${PB_CACHE_DIR}
      msg patch_wls INFO "Updating WLS Smart Update to v3.3.0"
      ${JAVA_HOME}/bin/java -jar ${PB_CACHE_DIR}/patch-client-installer330_generic32.jar -mode=silent -silent_xml=${BSU_RSP_FILE}
      rm -rf ${PB_CACHE_DIR}    # Clean up BSU cache directory 
    fi
    
    # Apply PSU first. The file MUST be manually renamed correctly
    # as we are expecting it to match a certain format such that the filtering works
    [ ! -d ${BSU_CACHE_DIR} ] && mkdir -p ${BSU_CACHE_DIR}    # Create BSU cache directory if it does not exist
    unzip -oq ${PB_DIR}/p*Generic-psu*.zip -d ${BSU_CACHE_DIR}
    psupatch=`basename $(ls -1 ${BSU_CACHE_DIR}/*.jar | cut -d '.' -f1)`        # Get just the patch ID name
    
    # Save current directory and switch to the location of bsu script as it cannot be called outside it's home (MOS 1326309.1; bug# 8478260)
    CURR_DIR=${PWD}
    cd ${BSU_DIR}
    msg patch_wls INFO "Applying PSU to WLS."
    ${BSU_DIR}/bsu.sh -install -patchlist=${psupatch} -patch_download_dir=${BSU_CACHE_DIR} -prod_dir=${WL_HOME} -log=${BSU_LOG}  

    # Check if other patches are available
    if [ `ls -l ${PB_DIR}/p*.zip 2>/dev/null | grep -v psu | grep -v bsu | wc -l` -gt 0 ]; then   # Not empty directory
      # Uncompress other patches in directory (in zip format) to cache dir and apply
      for fname in `ls -l ${PB_DIR}/p*.zip | grep -v psu | grep -v bsu`; do
        unzip -oq ${fname} -d ${BSU_CACHE_DIR}
      done

      # Apply other patches
      for patchname in `basename $(ls -1 ${BSU_CACHE_DIR}/*.jar | grep -v ${psupatch} | cut -d '.' -f1)`; do
        msg patch_wls INFO "Applying WLS patch ${patchname}."
        ${BSU_DIR}/bsu.sh -install -patchlist=${patchname} -patch_download_dir=${BSU_CACHE_DIR} -prod_dir=${WL_HOME} -log=${BSU_LOG}
      done
    fi
    cd ${CURR_DIR}
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
BSU_LOG=${LOG_DIR}/`echo ${SCRIPT} | awk -F"." '{print $1}'`-bsu.log

# Setup staging
RUN_DT=`date "+%Y%m%d-%H%M%S"`
STG_DIR=${STG_DIR}/install-${RUN_DT}
[ ! -d "${STG_DIR}" ] && mkdir -p ${STG_DIR}

create_silent_install_files
[ "${SKIP_JDK}" == "N" ] && install_jdk
install_wls
patch_wls

# END