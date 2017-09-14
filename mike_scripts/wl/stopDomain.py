bea_home = '/www/weblogic/weblogic12.1.1';
pathseparator = '/';
admin_username = 'weblogic';
admin_password = 'magic12c';
listen_address_machine1 = '172.31.0.175';
listen_address_machine2 = '172.31.0.113';
nodemanager_listen_port = '5556';
admin_server_listen_port = '7001';
domain_name = 'base_domain';

domain_home = bea_home + pathseparator + 'user_projects' + pathseparator + 'domains' + pathseparator + domain_name;
admin_server_url='t3://' + listen_address_machine2 + ':' + admin_server_listen_port;

print 'CONNECT TO NODE MANAGER ON MACHINE1';
nmConnect(admin_username, admin_password, listen_address_machine1, nodemanager_listen_port, domain_name, domain_home, 'ssl');

print 'CONNECT TO ADMIN SERVER';
connect(admin_username, admin_password, admin_server_url);

print 'STOPPING MANAGED SERVERS ON MACHINE1';
shutdown('server1','Server','true',1000,'true');
# server3 will be added in a later stadium when we scale the cluster
#shutdown('server3','Server','true',1000,'true');

print 'DISCONNECT FROM NODE MANAGER ON MACHINE1';
nmDisconnect();

print 'CONNECT TO NODE MANAGER ON MACHINE2';
nmConnect(admin_username, admin_password, listen_address_machine1, nodemanager_listen_port, domain_name, domain_home, 'ssl');

print 'STOPPING MANAGED SERVERS ON MACHINE2';
shutdown('server2','Server','true',1000,'true');

print 'STOPPING ADMIN SERVER ON MACHINE2';
shutdown('AdminServer','Server','true',1000,'true');

print 'DISCONNECT FROM NODE MANAGER ON MACHINE2';
nmDisconnect();
