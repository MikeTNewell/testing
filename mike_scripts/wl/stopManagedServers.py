######################################################
# NAME: stopManagedServers.py
#
# DESC: Stops Oracle WebLogic Server (WLS) domain Managed Servers.
#
# $HeadURL: $
# $LastChangedBy: cgwong $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user] - [notes]
# 2014/01/17 cgwong - [v1.0.0] Creation.
# 2014/03/19 cgwong - [v1.0.1] Used t3s connection.
#                     Switched to user config and key file for better
#                     security.
######################################################

import socket;

print 'CONNECT TO ADMIN SERVER';
aserver_listen_address = socket.gethostname();
aserver_url = 't3s://' + aserver_listen_address + ':' + aserver_listen_port;
##connect(aserver_username, aserver_password, aserver_url);
connect(userConfigFile=domain_home + aserver_cfg_file, userKeyFile=domain_home + aserver_key_file, url=aserver_url);

print 'STOPPING SERVERS';
domainRuntime();
server_lifecycles = cmo.getServerLifeCycleRuntimes();

for server_lifecycle in server_lifecycles:
  if (server_lifecycle.getState() == 'RUNNING' and server_lifecycle.getName() != aserver_name):
    print 'STOP SERVER ' + server_lifecycle.getName();
    task = server_lifecycle.shutdown(1000, java.lang.Boolean('true'));
    java.lang.Thread.sleep(1000);
    print task.getStatus() + ', ' + server_lifecycle.getState();
  else:
    print 'SERVER ' + server_lifecycle.getName() + ' is in ' + server_lifecycle.getState() + ' state and will not be stopped.';

print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
