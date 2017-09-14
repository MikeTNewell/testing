#!/bin/bash
######################################################
# NAME: WLSenv.sh
#
# DESC: User environment configuration.
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/04/15 cgwong - [v1.0.0] Creation.
######################################################

# Basic variables
WEB_BASE=/www/web
ORACLE_BASE=${WEB_BASE}/product ; export ORACLE_BASE
ENV=<env>; export ENV

# Domain variables
DOMAIN_HOST=`hostname -f` ; export DOMAIN_HOST

# Web Team specific variables
SHARE_BASE=/webshare                ; export SHARE_BASE
WEBTOOLS_HOME=/webtools             ; export WEB_TOOLS
SLIB_HOME=${WEB_TOOLS}/slib         ; export SLIB_HOME
WEB_BIN=${WEB_TOOLS}/bin            ; export WEB_BIN
STG_BASE=${WEB_TOOLS}/stage         ; export STG_BASE
WEBLOG_BASE=${WEB_BASE}/weblogs     ; export WEBLOG_BASE
KEYSTORE_BASE=${WEB_BASE}/keystore  ; export KEYSTORE_BASE
APPL_BASE=${WEB_BASE}/webapps       ; export APPL_BASE
DOMAIN_BASE=${WEB_BASE}/domains     ; export DOMAIN_BASE

JAVA_HOME=${ORACLE_BASE}/jdk        ; export JAVA_HOME

PATH=$JAVA_HOME/bin:$PATH           ; export PATH
