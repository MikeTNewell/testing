#!/bin/sh
######################################################
# NAME: WLSenv-inst-1036.sh
#
# DESC: Configures environment for WLS installation.
#
# NOTE: Due to constraints of the shell in regard to environment
#       variables, the command MUST be prefaced with ".". If it
#       is not, then no permanent change in the user's environment
#       can take place.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2013/09/12 cgwong - [v1.0.0] Creation.
# 2014/01/17 cgwong - [v1.0.1] Updated comments with version.
#                   - Updated variables and added more.
# 2014/01/21 cgwong - [v1.0.2] Added additional log variables.
# 2014/03/19 cgwong - [v1.1.0] Updated header comments.
#                     Removed variables not pertinent for installation.
#                     Renamed file to better reflect usage.
#                     Added additional variables.
# 2014/03/20 cgwong - [v1.2.0] Updated variables and added comments.
# 2014/03/21 cgwong - [v1.2.1] Corrected variable name error for WL_HOME.
# 2014/03/24 cgwong - [v1.2.2] Made specifics for each supported WLS version 
#                     for better building specific files.
#                     Default to 10.3.6 setup.
#                     Updated patching variables.
# 2014/03/25 cgwong - [v1.2.3] Updated some variables. 
# 2014/04/17 cgwong: [v1.2.4] Removed unneeded variables and updated others. 
# 2014/05/07 cgwong: [v1.2.5] Replaced PB_CACHE_DIR with BSU_CACHE_DIR. 
######################################################

# -- BASIC DIRECTORIES -- #
# Directory where the software to be installed is located
SLIB_DIR="/webtools/slib/wls" ; export SLIB_DIR

# The scripts create files that are placed in this directory
STG_DIR="/webtools/stage/wls" ; export STG_DIR

# Installation log directory
LOG_DIR="/webshare/weblogs/install" ; export LOG_DIR


# -- BASIC ORACLE VARIABLES -- #
# Base/root directory for installation
ORACLE_BASE="/www/web/product" ; export ORACLE_BASE

# Oracle inventory location
ORAINV_HOME="${ORACLE_BASE}/../oraInventory" ; export ORAINV_HOME

# Oracle inventory pointer file
ORAINV_PTR_FILE="/etc/oraInst.loc" ; export ORAINV_PTR_FILE

# Group under which the software needs to be installed
##OINST_GRP="web" ; export OINST_GRP

# -- FMW STACK DIRECTORIES -- #
# Middleware software home directory (stores binaries)
MW_HOME="${ORACLE_BASE}/fmw_1" ; export MW_HOME

# WebLogic Server software home directory for pre-12c
# Append appropriate "_major.minor" version designation for pre-12c if desired
WL_HOME="${MW_HOME}/wlserver_10.3" ; export WL_HOME

# Coherence software home directory for pre-12c
# Append appropriate "_major.minor" version designation for pre-12c if desired
##COHERENCE_HOME="${MW_HOME}/coherence_3.7" ; export COHERENCE_HOME

# Oracle Service Bus (OSB) software home directory for pre-12c
# Append appropriate "_major.minor" version designation for pre-12c if desired
OSB_HOME="${MW_HOME}/osb_11.1" ; export OSB_HOME


# -- JVM INFO -- #
# Name of JDK installation file
##JVM_FILE="${SLIB_DIR}/suppl/jdk-7u55-linux-x64.tar.gz" ; export JVM_FILE
JVM_FILE="${SLIB_DIR}/suppl/jrockit-jdk1.6.0_45-R28.2.7-4.1.0-linux-x64.bin" ; export JVM_FILE

# Directory where the JDK will be installed using version designation
##JVM_HOME="${ORACLE_BASE}/jdk1.7.0_55" ; export JVM_HOME
JVM_HOME="${ORACLE_BASE}/jrockit-jdk1.6.0_45-R28.2.7-4.1.0" ; export JVM_HOME

# Directory where the JVM will be run using non-version designation
##JAVA_HOME="${ORACLE_BASE}/jdk" ; export JAVA_HOME
JAVA_HOME="${ORACLE_BASE}/jrockit-jdk" ; export JAVA_HOME

# JVM home name for Oracle Inventory
##JVM_HOME_NAME="Oracle_JDK7u55" ; export JVM_HOME_NAME
JVM_HOME_NAME="Oracle_JRockit6u45" ; export JVM_HOME_NAME

# Name of the JRockit response installation file for pre-JDK7
JVM_RSP_FILE="${SLIB_DIR}/resp/silent-jrockit.xml" ; export JVM_RSP_FILE

# JDK extract name
##JDK_DEFAULT_NAME="jdk1.7.0_55" ; export JDK_DEFAULT_NAME


# -- DOMAIN INFO -- #
# Hostname of target installation server
TGT_HOST=`hostname -f` ; export TGT_HOST


# -- WL FILE INFO -- #
# Name of the WebLogic installation file
##WL_FILE="${SLIB_DIR}/wls_121200.jar" ; export WL_FILE
##WL_FILE="${SLIB_DIR}/wls1035_generic.jar" ; export WL_FILE
WL_FILE="${SLIB_DIR}/wls1036_generic.jar" ; export WL_FILE

# Name of the WebLogic 12c response installation file
##WL_RSP_FILE="${SLIB_DIR}/resp/wls12c-inst.rsp" ; export WL_RSP_FILE
WL_RSP_FILE="${SLIB_DIR}/resp/silent-wls.xml" ; export WL_RSP_FILE


# -- PATCH INFO -- #
# BSU directory
BSU_DIR=${MW_HOME}/utils/bsu ; export BSU_DIR

# BSU/Smart Update response file
BSU_RSP_FILE="${SLIB_DIR}/resp/silent-bsu.xml"; export BSU_RSP_FILE

# BSU patch cache directory
BSU_CACHE_DIR=${BSU_DIR}/cache_dir ; export BSU_CACHE_DIR

# Patch bundle designation to apply
PB="wls_1036_pb1" ; export PB

# Patch bundle directory
PB_DIR=${SLIB_DIR}/patches/${PB} ; export PB_DIR

# Name of the OCM response file
#OCM_RSP_FILE=${SLIB_DIR}/resp/ocm.rsp ; export OCM_RSP_FILE
