#!/bin/sh
 
# Name of the domain
DOMAIN_NAME="config_domain"
export DOMAIN_NAME
 
# Directory where the software to be installed is located
SOFTWARE_DIRECTORY="/u01/software/weblogic/12.1.3"
export SOFTWARE_DIRECTORY
 
# The scripts create files that are placed in this directory
TEMPORARY_DIRECTORY="/home/weblogic/temp/files"
export TEMPORARY_DIRECTORY
 
# Name of JVM file
JVM_FILE_NAME="jdk-7u55-linux-x64.gz"
export JVM_FILE_NAME
 
# Name of the WebLogic file
WEBLOGIC_FILE_NAME="fmw_12.1.3.0.0_infrastructure.jar"
export WEBLOGIC_FILE_NAME
 
# Name of the httpd file
OSB_FILE_NAME="fmw_12.1.3.0.0_osb.jar"
export HTTPD_FILE_NAME
 
# Base directory
BASE_DIRECTORY="/u01/app/oracle"
export BASE_DIRECTORY
 
# Directory that will used for the installation and configuration
RUNTIME_HOME="${BASE_DIRECTORY}/osb12.1.3"
export RUNTIME_HOME
 
# Directory where the JVM will be installed
JAVA_HOME="${RUNTIME_HOME}/jdk1.7.0_55"
export JAVA_HOME
 
# Directory that will be used as the middleware home (holds software binaries)
MIDDLEWARE_HOME="${RUNTIME_HOME}/installation"
export MIDDLEWARE_HOME
 
# Defaults homes that are created when the software is installed
COHERENCE_HOME="${MIDDLEWARE_HOME}/coherence"
export COHERENCE_HOME
FUSION_MIDDLEWARE_HOME="${MIDDLEWARE_HOME}/oracle_common"
export FUSION_MIDDLEWARE_HOME
OSB_HOME="${MIDDLEWARE_HOME}/osb"
export OSB_HOME
WEBLOGIC_HOME="${MIDDLEWARE_HOME}/wlserver"
export WEBLOGIC_HOME
 
# Location of the Oracle inventory
ORACLE_INVENTORY_HOME="${BASE_DIRECTORY}/oraInventory"
export ORACLE_INVENTORY_HOME
 
# Group under which the software needs to be installed
ORACLE_INSTALL_GROUP="javainstall"
export ORACLE_INSTALL_GROUP
 
# Directory where the configuration will be placed
CONFIGURATION_HOME="${RUNTIME_HOME}/configuration"
export CONFIGURATION_HOME
