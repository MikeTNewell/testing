######################################################
# NAME: startNodeManager.py
#
# DESC: Starts Node Manager for Oracle WebLogic Server (WLS) domain.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/01/17 cgwong - [v1.0.0] Creation.
# 2014/03/20 cgwong - [v1.0.1] Updated cfg_home and fmw_home variables.
######################################################

import socket;
nm_listen_address = socket.gethostname();

print 'CREATE PATHS';
domain_name = os.getenv('DOMAIN_NAME');
java_home = os.getenv('JAVA_HOME');
mw_home = os.getenv('MW_HOME');
wls_home = os.getenv('WL_HOME');
fmw_home = os.getenv('FMW_HOME');
cfg_home = os.getenv('CFG_BASE');

domain_home = cfg_home + '/domains/' + domain_name;
domain_application_home = cfg_home + '/webapps/' + domain_name;
nm_home = domain_home + '/nodemanager';

print 'STARTING NODE MANAGER';
startNodeManager(verbose='true', NodeManagerHome=nm_home, ListenPort=nm_listen_port, ListenAddress=nm_listen_address);
