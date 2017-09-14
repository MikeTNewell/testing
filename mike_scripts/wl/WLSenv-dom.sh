#!/bin/sh
######################################################
# NAME: WLSenv-dom.sh
#
# DESC: Configures environment for WLS deployments.
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
# 2014/03/20 cgwong - [v1.0.0] Creation.
######################################################

# -- BASIC DIRECTORIES -- #
# Directory where the software to be installed is located
SLIB_DIR="/webtools/slib/wls" ; export SLIB_DIR

# The scripts create files that are placed in this directory
STG_DIR="/webtools/stage/wls" ; export STG_DIR

# Deploy log directory
LOG_DIR="/webshare/weblogs/deploy" ; export LOG_DIR

# Configuration base directory
CFG_BASE="/webshare" ; export CFG_BASE

# -- BASIC ORACLE VARIABLES -- #
# Base directory for installation
ORACLE_BASE="/www/web/product" ; export ORACLE_BASE

# Oracle inventory location
ORAINV_HOME="${ORACLE_BASE}/oraInventory" ; export ORAINV_HOME

# Oracle inventory pointer file
ORAINV_PTR_FILE="/etc/oraInst.loc" ; export ORAINV_PTR_FILE

# Group under which the software needs to be installed
OINST_GRP="web" ; export OINST_GRP

# -- FMW STACK DIRECTORIES -- #
# Middleware software home directory (stores binaries)
MW_HOME="${ORACLE_BASE}/fmw_1" ; export MW_HOME

# Fusion Middleware software installation
FMW_HOME="${MW_HOME}/oracle_common" ; export FMW_HOME

# WebLogic Server software home directory. 
# Append appropriate "_major.minor" version designation
WL_HOME="${MW_HOME}/wlserve_10.3" ; export WL_HOME
##WL_HOME="${MW_HOME}/wlserve_12.1" ; export WL_HOME

# Coherence software home directory
# Append appropriate "_major.minor" version designation
COHERENCE_HOME="${MW_HOME}/coherence_3.7" ; export COHERENCE_HOME
##COHERENCE_HOME="${MW_HOME}/coherence_12.1" ; export COHERENCE_HOME

# Oracle Service Bus (OSB) software home directory
# Append appropriate "_major.minor" version designation
OSB_HOME="${MW_HOME}/osb_11.1" ; export OSB_HOME

# -- JVM INFO -- #
# Type of JDK to use whether JDK or JRockit
##JVM_RELEASE="JDK" ; export JVM_RELEASE
JVM_RELEASE="JROCKIT" ; export JVM_RELEASE

# Name of JDK installation file
##JVM_FILE="jdk-7u51-linux-x64.tar.gz" ; export JVM_FILE
JVM_FILE="jrockit-jdk1.6.0_45-R28.2.7-4.1.0-linux-x64.bin" ; export JVM_FILE

# Directory where the JDK will be installed using version designation
##JVM_HOME="${ORACLE_BASE}/jdk1.7.0_51" ; export JVM_HOME
JVM_HOME="${ORACLE_BASE}/jrockit-jdk1.6.0_45-R28.2.7-4.1.0" ; export JVM_HOME

# Directory where the JVM will be run using non-version designation
JAVA_HOME="${ORACLE_BASE}/jdk" ; export JAVA_HOME

# -- DOMAIN INFO -- #
# Name of the domain
DOMAIN_NAME="dom_base" ; export DOMAIN_NAME

# Hostname of target installation server
TGT_HOST=`hostname -f` ; export TGT_HOST

# -- DEPLOYMENT HEAP INFO -- #
# Admin Server JVM sizes
ASVR_HEAP_SZ=512m
ASVR_PERM_SZ=256m

# Managed Server JVM sizes
MSRV_HEAP_SZ=1024m
MSRV_PERM_SZ=512m

# Coherence JVM sizes
CSRV_HEAP_SZ=2048m
CSRV_PERM_SZ=512m
