######################################################
# NAME: StoreUserConfigService.py
#
# DESC: Creates user config and key file to store 
#       secure credentials.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/03/19 cgwong - [v1.0.0] Creation.
# 2014/03/20 cgwong - [v1.0.1] Updated cfg_home and fmw_home variables.
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

print 'CONNECT TO NODE MANAGER';
nmConnect(nm_username, nm_password, nm_listen_address, nm_listen_port, domain_name, domain_home, nm_mode);

print 'CREATE NODE MANAGER USER CONFIG FILES';
storeUserConfig(domain_home + nm_cfg_file, domain_home + nm_key_file, 'true');

print 'DISCONNECT FROM NODE MANAGER';
nmDisconnect();

print 'CONNECT TO ADMIN SERVER';
aserver_url = 't3s://' + aserver_listen_address + ':' + aserver_listen_port;
connect(aserver_username, aserver_password, aserver_url);

print 'CREATE ADMIN SERVER USER CONFIG FILES';
storeUserConfig(domain_home + aserver_cfg_file, domain_home + aserver_key_file, 'false');

print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
