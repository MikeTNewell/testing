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

print 'CONNECT TO NODE MANAGER ON MACHINE2';
nmConnect(admin_username, admin_password, listen_address_machine2, nodemanager_listen_port, domain_name, domain_home, 'ssl');

print 'START ADMIN SERVER ON MACHINE2';
nmStart('AdminServer');

print 'CONNECT TO ADMIN SERVER';
connect(admin_username, admin_password, admin_server_url);

print 'START MANAGED SERVERS ON MACHINE2';
start('server2','Server');

print 'DISCONNECT FROM NODE MANAGER ON MACHINE2';
nmDisconnect();

print 'CONNECT TO NODE MANAGER ON MACHINE1';
nmConnect(admin_username, admin_password, listen_address_machine1, nodemanager_listen_port, domain_name, domain_home, 'ssl');

print 'START MANAGED SERVERS ON MACHINE1';
start('server1','Server');
# server3 will be added in a later stadium when we scale the cluster
#start('server3','Server');

print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();

print 'DISCONNECT FROM NODE MANAGER ON MACHINE1';
nmDisconnect();
