######################################################
# NAME: stopAdminServer.py
#
# DESC: Stops Oracle WebLogic Server (WLS) domain Administration Server.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/01/17 cgwong - [v1.0.0] Creation.
# 2014/03/19 cgwong - [v1.1.0] Switched node manager connection to use
#                     user store and key file syntax for improved security.
#                     Updated header comments.
# 2014/03/20 cgwong - [v1.1.1] Updated cfg_home and fmw_home variables.
######################################################

import socket;
nm_listen_address = socket.gethostname();
aserver_listen_address = nm_listen_address;

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

print 'CONNECT TO ADMIN SERVER';
aserver_url = 't3s://' + aserver_listen_address + ':' + aserver_listen_port;
connect(aserver_username, aserver_password, aserver_url);

print 'CONNECT TO NODE MANAGER';
##nmConnect(nm_username, nm_password, nm_listen_address, nm_listen_port, domain_name, domain_home, nm_mode);
nmConnect(userConfigFile=domain_home + nm_cfg_file, userKeyFile=domain_home + nm_key_file, host=nm_listen_address, port=nm_listen_port, domainName=domain_name, domainDir=domain_home, nmType=nm_mode);

print 'STOPPING ADMIN SERVER';
shutdown(aserver_name,'Server','true',1000,'true');

print 'DISCONNECT FROM NODE MANAGER';
nmDisconnect();
