#!/bin/bash
 
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
 
. ${SCRIPT_PATH}/../SetEnvironmentVariables.sh
 
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
 
#Set this variable value to the Installation Type selected. e.g. Fusion Middleware Infrastructure, Fusion Middleware Infrastructure With Examples.
INSTALL_TYPE=Fusion Middleware Infrastructure
 
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
 
    echo '[ENGINE]
 
#DO NOT CHANGE THIS.
Response File Version=1.0.0.0.0
 
[GENERIC]
 
#The oracle home location. This can be an existing Oracle Home or a new Oracle Home
ORACLE_HOME='${MIDDLEWARE_HOME}'
 
#Set this variable value to the Installation Type selected. e.g. Service Bus.
INSTALL_TYPE=Service Bus' > ${TEMPORARY_DIRECTORY}/silent-osb.txt 
 
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
    sed '/securerandom/ s_file:/dev/urandom_file:/dev/./urandom_' ${JAVA_HOME}/jre/lib/security/java.security > ${TEMPORARY_DIRECTORY}/java.security
    mv ${TEMPORARY_DIRECTORY}/java.security ${JAVA_HOME}/jre/lib/security/java.security
}
 
install_weblogic() {
    echo 'INSTALLING WEBLOGIC SERVER'
    ${JAVA_HOME}/bin/java -Xms1024m -Xmx1024m -jar ${SOFTWARE_DIRECTORY}/${WEBLOGIC_FILE_NAME} -silent -responseFile ${TEMPORARY_DIRECTORY}/silent-weblogic.txt -invPtrLoc ${TEMPORARY_DIRECTORY}/oraInst.loc
}
 
install_oracle_service_bus() {
    echo 'INSTALLING ORACLE SERVICE BUS'
    ${JAVA_HOME}/bin/java -Xms1024m -Xmx1024m -jar ${SOFTWARE_DIRECTORY}/${OSB_FILE_NAME} -silent -responseFile ${TEMPORARY_DIRECTORY}/silent-osb.txt -invPtrLoc ${TEMPORARY_DIRECTORY}/oraInst.loc
}
 
create_repository() {
    echo 'CREATING REPOSITORY'
    ${FUSION_MIDDLEWARE_HOME}/bin/rcu -silent -createRepository -databaseType ORACLE -connectString r-pc:1521:orcl12 -dbUser sys -dbRole SYSDBA -schemaPrefix SOA -useSamePasswordForAllSchemaUsers true -component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component UCSUMS -component WLS -component STB -component SOAINFRA -f < ${SCRIPT_PATH}/passwordfile.txt
}
 
drop_repository() {
    echo 'DROPPING REPOSITORY'
    ${FUSION_MIDDLEWARE_HOME}/bin/rcu -silent -dropRepository -databaseType ORACLE -connectString r-pc:1521:orcl12 -dbUser sys -dbRole SYSDBA -schemaPrefix SOA -component MDS -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component UCSUMS -component WLS -component STB -component SOAINFRA -f < ${SCRIPT_PATH}/passwordfile.txt
}
 
create_silent_install_files
 
install_jdk
 
install_weblogic
 
install_oracle_service_bus
 
create_repository
 
#drop_repository
