#!/bin/bash
 
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
 
#. ${SCRIPT_PATH}/../SetEnvironmentVariables.sh

. ./SetEnvironmentVariables.sh
 
if [ ! -d "${TEMPORARY_DIRECTORY}" ]; then
    mkdir -p ${TEMPORARY_DIRECTORY}
fi
 
create_silent_install_files() {
    echo 'CREATING SILENT INSTALL FILES'
 
    echo '[ENGINE]
 
#DO NOT CHANGE THIS.
Response File Version=1.0.0.0.0
 
[GENERIC]
 
#The oracle home location. This can be an existing Oracle Home or a new Oracle Home
ORACLE_HOME='${MIDDLEWARE_HOME}'
 
#Set this variable value to the Installation Type selected. e.g. WebLogic Server, Coherence, Complete with Examples.
INSTALL_TYPE=WebLogic Server
 
#Provide the My Oracle Support Username. If you wish to ignore Oracle Configuration Manager configuration provide empty string for user name.
MYORACLESUPPORT_USERNAME=
 
#Provide the My Oracle Support Password
MYORACLESUPPORT_PASSWORD=<SECURE VALUE>
 
#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration
DECLINE_SECURITY_UPDATES=true
 
#Set this to true if My Oracle Support Password is specified
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
 
#Provide the Proxy Host
PROXY_HOST=
 
#Provide the Proxy Port
PROXY_PORT=
 
#Provide the Proxy Username
PROXY_USER=
 
#Provide the Proxy Password
PROXY_PWD=<SECURE VALUE>
 
#Type String (URL format) Indicates the OCM Repeater URL which should be of the format [scheme[Http/Https]]://[repeater host]:[repeater port]
COLLECTOR_SUPPORTHUB_URL=' > ${TEMPORARY_DIRECTORY}/silent-weblogic.txt
 
    echo 'inventory_loc='${ORACLE_INVENTORY_HOME}'
inst_group='${ORACLE_INSTALL_GROUP}'' > ${TEMPORARY_DIRECTORY}/oraInst.loc
}
 
install_jdk() {
    if [ ! -d "${RUNTIME_HOME}" ]; then
        mkdir -p ${RUNTIME_HOME}
    fi
 
    echo 'INSTALLING JAVA VIRTUAL MACHINE'
    tar xzf ${SOFTWARE_DIRECTORY}/${JVM_FILE_NAME} -C ${RUNTIME_HOME}
 
    echo 'ADJUST ENTROPY GATHERING DEVICE SETTINGS'
    sed -i.bak -e '/securerandom/ s;file:/dev/urandom;file:/dev/./urandom;' \
     -e '/securerandom/ s;file:/dev/random;file:/dev/./urandom;' ${JAVA_HOME}/jre/lib/security/java.security
}
 
install_weblogic() {
    echo 'INSTALLING WEBLOGIC SERVER'
    ${JAVA_HOME}/bin/java -Xms512m -Xmx512m -jar ${SOFTWARE_DIRECTORY}/${WEBLOGIC_FILE_NAME} -silent -novalidation -response ${TEMPORARY_DIRECTORY}/silent-weblogic.txt -invPtrLoc ${TEMPORARY_DIRECTORY}/oraInst.loc
}
 
create_silent_install_files
 
install_jdk
 
install_weblogic

