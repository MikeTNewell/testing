#!/bin/sh
 
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
 
. ${SCRIPT_PATH}/../SetEnvironmentVariables.sh
 
unpack_domain() {
    ${WEBLOGIC_HOME}/common/bin/unpack.sh -domain=${CONFIGURATION_HOME}/domains/${DOMAIN_NAME} -app_dir=${CONFIGURATION_HOME}/applications/${DOMAIN_NAME} -template=${TEMPORARY_DIRECTORY}/templates/${DOMAIN_NAME}.jar
}
 
change_domain() {
    ${WEBLOGIC_HOME}/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/change_domain.py
 
    mkdir -p ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/nodemanager/security
    cp ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/security/DemoIdentity.jks ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/nodemanager/security
}
 
change_memory_settings() {
    echo 'CHANGE DERBY FLAG'
    sed -i -e '/DERBY_FLAG="true"/ s:DERBY_FLAG="true":DERBY_FLAG="false":' ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/bin/setDomainEnv.sh
 
    echo 'CHANGE MEMORY SETTINGS'
    ADMIN_SERVER_HEAP_SIZE=1048m
    ADMIN_SERVER_PERM_SIZE=512m
    MANAGED_SERVER_HEAP_SIZE=1024m
    MANAGED_SERVER_PERM_SIZE=512m
    COHERENCE_SERVER_HEAP_SIZE=512m
    COHERENCE_SERVER_PERM_SIZE=256m
 
    touch ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh
    chmod u+x ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh
 
    echo '#!/bin/sh
 
ADMIN_SERVER_MEM_ARGS="-Xms'${ADMIN_SERVER_HEAP_SIZE}' -Xmx'${ADMIN_SERVER_HEAP_SIZE}' -XX:PermSize='${ADMIN_SERVER_PERM_SIZE}' -XX:MaxPermSize='${ADMIN_SERVER_PERM_SIZE}'"
SERVER_MEM_ARGS="-Xms'${MANAGED_SERVER_HEAP_SIZE}' -Xmx'${MANAGED_SERVER_HEAP_SIZE}' -XX:PermSize='${MANAGED_SERVER_PERM_SIZE}' -XX:MaxPermSize='${MANAGED_SERVER_PERM_SIZE}'"
COHERENCE_SERVER_MEM_ARGS="-Xms'${COHERENCE_SERVER_HEAP_SIZE}' -Xmx'${COHERENCE_SERVER_HEAP_SIZE}' -XX:PermSize='${COHERENCE_SERVER_PERM_SIZE}' -XX:MaxPermSize='${COHERENCE_SERVER_PERM_SIZE}'"
MONITORING_ARGS="-XX:+UnlockCommercialFeatures -XX:+FlightRecorder"
COHERENCE_MONITORING_ARGS="-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true"
GARBAGE_COLLECTOR_ARGS="-XX:NewRatio=3 -XX:SurvivorRatio=128 -XX:MaxTenuringThreshold=0 -XX:+UseParallelGC -XX:MaxGCPauseMillis=200 -XX:GCTimeRatio=19 -XX:+UseParallelOldGC -XX:+UseTLAB"
LARGE_PAGES_ARGS="-XX:LargePageSizeInBytes=2048k -XX:+UseLargePages"
 
if [ "${ADMIN_URL}" = "" ] ; then
    USER_MEM_ARGS="${ADMIN_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"
else
    case ${SERVER_NAME} in
        server_*)
            USER_MEM_ARGS="${SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${MONITORING_ARGS}"
        ;;
        coherence_server_1)
            USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${COHERENCE_MONITORING_ARGS}"
        ;;
        coherence_server_*)
            USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"
        ;;
    esac
fi
export USER_MEM_ARGS
 
#if [ "${WEBLOGIC_EXTENSION_DIRS}" != "" ] ; then
# WEBLOGIC_EXTENSION_DIRS="${WEBLOGIC_EXTENSION_DIRS}${CLASSPATHSEP}${DOMAIN_HOME}/lib"
#else
# WEBLOGIC_EXTENSION_DIRS="${DOMAIN_HOME}/lib"
#fi
#export WEBLOGIC_EXTENSION_DIRS' > ${CONFIGURATION_HOME}/domains/${DOMAIN_NAME}/bin/setUserOverrides.sh
}
 
unpack_domain
 
change_domain
 
change_memory_settings
