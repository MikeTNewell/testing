#!/bin/bash
SCRIPT_DIR=`pwd`
ORAINVENTORY_HOME=/opt/oracle/oraInventory
ORACLE_HOME=/opt/oracle/wls12c
# Set the environment variables


export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export PATH=$PATH:$JAVA_HOME/bin

[ -z  "$JAVA_HOME" ] &&  echo -e "JAVA_HOME is not set" && exit 1  || echo -e "JAVA_HOME $JAVA_HOME is set"

echo "JAVA_HOME is set to ************ " $JAVA_HOME
echo "PATH is set to *****************" $PATH

# Check Error
checkError () {
if [ $? -ne 0 ]
 then
   echo $2
   exit
fi
}

if [ -d ${ORAINVENTORY_HOME}  ] ; then
	echo "Directory exists" 
else
	echo "Directory does not exist"
	echo "Creating the directory"
	mkdir -p ${ORAINVENTORY_HOME}
	checkError
fi
# Add the contents of the File

locfile()
{
cat << EOF > ${ORAINVENTORY_HOME}/oraInst.loc
#############################
#Oracle Installer Location File Location
inst_group=mwsadmin
inventory_loc=${ORAINVENTORY_HOME}
#####################################
EOF
}

if [ -f ${ORAINVENTORY_HOME}/oraInst.loc ] ;then
	echo "File exists" 
else
	echo "File does not exist"
	echo "Creating the File"
	touch ${ORAINVENTORY_HOME}/oraInst.loc 
	checkError
	echo  "Adding Contents to the loc file" 
	locfile
fi


Create_Response_file()
{
cat << EOF > ${SCRIPT_DIR}/response_file
########################################
[ENGINE]
 
#DO NOT CHANGE THIS.
Response File Version=1.0.0.0.0
 
[GENERIC]
 
#The oracle home location. This can be an existing Oracle Home or a new Oracle Home
ORACLE_HOME=$ORACLE_HOME
 
#Set this variable value to the Installation Type selected. e.g. Fusion Middleware Infrastructure, Fusion Middleware Infrastructure With Examples.
INSTALL_TYPE=Complete with Examples


#Set this to true if you wish to decline the security updates. Setting this to true and providing empty string for My Oracle Support username will ignore the Oracle Configuration Manager configuration
DECLINE_SECURITY_UPDATES=true
########################################
EOF
}
> ${SCRIPT_DIR}/response_file


deployWLS_1212_bin()
{
if [ ! -d $ORACLE_HOME ] && [ -f ${SCRIPT_DIR}/wls_121200.jar ];
then
    echo -e "Now Deploying the Weblogic version 12.1.2.0 binary"
	# Creating the Response file
	echo -e "Creating the Response file for silent install"
	Create_Response_file
	java -jar ${SCRIPT_DIR}/wls_121200.jar -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom  -silent -response ${SCRIPT_DIR}/response_file -invPtrLoc ${ORAINVENTORY_HOME}/oraInst.loc
    echo -e "Done Deploying the binary for Weblogic version 12.1.2.0"
    echo -e ""

else
    echo -e "Either the Weblogic binary is not present in the ${SCRIPT_DIR}"
    echo -e "or the /opt/oracle/wls12c is occupied"
    exit 1
fi
}


deployWLS_1212_bin
