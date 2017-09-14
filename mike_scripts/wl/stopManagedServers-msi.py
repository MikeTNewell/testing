######################################################
# NAME: stopManagedServers-msi.py
#
# DESC: Stops WLS local Managed Server in independence mode.
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
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;

print 'CREATE PATHS';
domain_name = os.getenv('DOMAIN_NAME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MW_HOME');
weblogic_home = os.getenv('WL_HOME');
fmw_home = os.getenv('FMW_HOME');
cfg_home = os.getenv('CFG_BASE');

domain_home = cfg_home + '/domains/' + domain_name;
domain_application_home = cfg_home + '/webapps/' + domain_name;
nm_home = domain_home + '/nodemanager';

print 'OBTAIN SERVER NAMES';
defiles = java.io.File(domain_home + '/servers');
delist = java.util.Arrays.asList(defiles.list());
denames = java.util.ArrayList(delist);

print 'CONNECT TO NODE MANAGER';
nm_listen_address = socket.gethostname();
##nmConnect(nm_username, nm_password, nm_listen_address, nm_listen_port, domain_name, domain_home, nm_mode);
nmConnect(userConfigFile=domain_home + nm_cfg_file, userKeyFile=domain_home + nm_key_file, host=nm_listen_address, port=nm_listen_port, domainName=domain_name, domainDir=domain_home, nmType=nm_mode);

print 'STARTING SERVERS';
for dename in denames:
  if (dename != aserver_name and dename != 'domain_bak'):
    # nmStart(dename);

print 'DISCONNECT FROM NODE MANAGER';
nmDisconnect();
