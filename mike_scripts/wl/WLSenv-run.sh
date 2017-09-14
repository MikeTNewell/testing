#!/bin/sh
######################################################
# NAME: WLSenv-run.sh
#
# DESC: Configures environment for WLS runtime lifecycle.
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
# 2014/03/19 cgwong - [v1.0.3] Updated header comments.
#                     Removed variables not pertinent for runtime.
#                     Renamed file to better reflect usage.
# 2014/03/20 cgwong - [v1.2.0] Updated variables.
######################################################

# -- BASIC DIRECTORIES -- #
# Configuration base directory
CFG_BASE="/webshare" ; export CFG_BASE

# -- BASIC ORACLE VARIABLES -- #
# Base directory for installation
ORACLE_BASE="/www/web/product" ; export ORACLE_BASE

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
# Directory where the JVM will be run using non-version designation
JAVA_HOME="${ORACLE_BASE}/jdk" ; export JAVA_HOME

# -- DOMAIN INFO -- #
# Name of the domain
DOMAIN_NAME="base_domain" ; export DOMAIN_NAME

# Hostname of target installation server
TGT_HOST=`hostname -f` ; export TGT_HOST
