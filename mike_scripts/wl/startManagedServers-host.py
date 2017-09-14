######################################################
# NAME: startManagedServers-host.py
#
# DESC: Starts WLS local Managed Servers.
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
nm_listen_ip_address = socket.gethostbyname(nm_listen_address);

print 'CREATE PATHS';
domain_name = os.getenv('DOMAIN_NAME');
java_home = os.getenv('JAVA_HOME');
mw_home = os.getenv('MM_HOME');
wls_home = os.getenv('WL_HOME');
fmw_home = os.getenv('FMW_HOME');
cfg_home = os.getenv('CFG_BASE');

domain_home = cfg_home + '/domains/' + domain_name;
domain_application_home = cfg_home + '/webapps/' + domain_name;
nm_home = domain_home + '/nodemanager';

print 'CONNECT TO ADMIN SERVER';
command_output = os.popen('find ' + domain_home + ' -name startup.properties');
output = command_output.readline();
command_output.close();
loadProperties(output.rstrip());
aserver_url = AdminURL.replace('https','t3s');
##connect(aserver_username, aserver_password, aserver_url);
connect(userConfigFile=domain_home + aserver_cfg_file, userKeyFile=domain_home + aserver_key_file, url=aserver_url);

print 'CONNECT TO NODE MANAGER ON ' + nm_listen_address + ':' + repr(nm_listen_port);
##nmConnect(nm_username, nm_password, nm_listen_address, nm_listen_port, domain_name, domain_home, nm_mode);
nmConnect(userConfigFile=domain_home + nm_cfg_file, userKeyFile=domain_home + nm_key_file, host=nm_listen_address, port=nm_listen_port, domainName=domain_name, domainDir=domain_home, nmType=nm_mode);

domainRuntime();
cd('ServerRuntimes');
server_runtimes = ls(returnMap='true');
for server_runtime in server_runtimes:
  cd(server_runtime);
  if (cmo.getName() != aserver_name):
    host = cmo.getListenAddress().split('/');
    if (nm_listen_address == host[0] or nm_listen_ip_address == host[1]):
      print 'START SERVER ' + cmo.getName();
      nmStart(cmo.getName());
    else:
      print 'SERVER ' + cmo.getName() + ' runs on a different host and will not be started.';
  else:
    print 'SERVER ' + cmo.getName() + ' is the Admin Server and will not be started.';
    cd('..');

print 'DISCONNECT FROM NODE MANAGER ON ' + nm_listen_address + ':' + repr(nm_listen_port);
nmDisconnect();

print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
