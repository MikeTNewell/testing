export SCRIPTS=$HOME/Newell_Rusniak/mike_scripts
export ORACLE_BASE=/data/app
export MW_HOME=/data/app/wl_12.2.1
export WLS_HOME=$MW_HOME/wlserver
export WL_HOME=$WLS_HOME
export JAVA_HOME=/data/app/wl_12.2.1/jdk1.8.0_73
export PATH=$JAVA_HOME/bin:$WL_HOME/server/bin:$PATH

. $WL_HOME/server/bin/setWLSEnv.sh

# Weblogic Domains
export DOMAIN_HOME=$ORACLE_BASE/config/domains/mydomain

java weblogic.WLST $SCRIPTS/wl/wlsDomainCreationAndConfiguration.py 
