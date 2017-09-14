import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
 
def createFile(directory_name, file_name, content):
    dedirectory = java.io.File(directory_name);
    defile = java.io.File(directory_name + '/' + file_name);
 
    writer = None;
    try:
        dedirectory.mkdirs();
        defile.createNewFile();
        writer = java.io.FileWriter(defile);
        writer.write(content);
    finally:
        try:
            print 'WRITING FILE ' + file_name;
            if writer != None:
                writer.flush();
                writer.close();
        except java.io.IOException, e:
            e.printStackTrace();
 
print 'SETTING PARAMETERS';
cluster_name='osb_cluster';
machine_listen_addresses=['machine1.com','machine2.com'];
machine_user_id='weblogic';
machine_group_id='javainstall';
number_of_managed_servers_per_machine=1;
managed_server_listen_port_start=9001;
server_groups=['OSB-MGD-SVRS-COMBINED'];
 
data_source_url='jdbc:oracle:thin:@//r-pc:1521/orcl12';
data_source_driver='oracle.jdbc.OracleDriver';
data_source_user_prefix='SOA';
data_source_password='oracle12c';
data_source_test='SQL SELECT 1 FROM DUAL';
 
print 'CREATE PATHS';
domain_name=os.getenv('DOMAIN_NAME');
java_home=os.getenv('JAVA_HOME');
middleware_home=os.getenv('MIDDLEWARE_HOME');
weblogic_home=os.getenv('WEBLOGIC_HOME');
fusion_middleware_home=os.getenv('FUSION_MIDDLEWARE_HOME');
configuration_home = os.getenv('CONFIGURATION_HOME');
 
domain_home=configuration_home + '/domains/' + domain_name;
domain_application_home=configuration_home + '/applications/' + domain_name;
node_manager_home=domain_home + '/nodemanager';
 
weblogic_template=middleware_home + '/wlserver/common/templates/wls/wls.jar';
osb_template=middleware_home + '/osb/common/templates/wls/oracle.osb_template_12.1.3.jar';
ws_template=middleware_home + '/oracle_common/common/templates/wls/oracle.wls-webservice-template_12.1.3.jar';
xquery_template=middleware_home + '/oracle_common/common/templates/wls/oracle.odsi.xquery2004_template_12.1.3.jar';
em_template=middleware_home + '/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar';
owsm_template=middleware_home + '/oracle_common/common/templates/wls/oracle.wsmpm_template_12.1.3.jar';
jrf_template=middleware_home + '/oracle_common/common/templates/wls/oracle.jrf_template_12.1.3.jar';
coherence_template=middleware_home + '/wlserver/common/templates/wls/wls_coherence_template_12.1.3.jar';
 
print 'CREATE DOMAIN';
readTemplate(weblogic_template);
setOption('DomainName', domain_name);
setOption('OverwriteDomain', 'true');
setOption('JavaHome', java_home);
setOption('ServerStartMode', 'prod');
cd('/Security/base_domain/User/weblogic');
cmo.setName(admin_username);
cmo.setUserPassword(admin_password);
cd('/');
 
print "SAVE DOMAIN";
writeDomain(domain_home);
closeTemplate();
 
print 'READ DOMAIN';
readDomain(domain_home);
 
print 'ADD TEMPLATES';
addTemplate(osb_template);
# The next templates are already selected by adding the ohs template
#addTemplate(ws_template);
#addTemplate(xquery_template);
#addTemplate(em_template);
#addTemplate(owsm_template);
#addTemplate(jrf_template);
#addTemplate(coherence_template);
setOption('AppDir', domain_application_home);
 
print 'CREATE CLUSTER';
cluster = create(cluster_name,'Cluster');
cluster.setClusterMessagingMode('unicast');
 
print 'CREATING MACHINES AND (ADJUSTING) SERVERS';
for i in range(len(machine_listen_addresses)):
    print 'CREATING MACHINE' + repr(i);
    machine = create('machine_' + machine_listen_addresses[i],'UnixMachine');
    machine.setPostBindUIDEnabled(java.lang.Boolean('true'));
    machine.setPostBindUID(machine_user_id);
    machine.setPostBindGIDEnabled(java.lang.Boolean('true'));
    machine.setPostBindGID(machine_group_id);
    cd('/Machine/' + machine.getName());
    nodemanager = create(machine.getName(),'NodeManager');
    nodemanager.setListenAddress(machine_listen_addresses[i]);
    nodemanager.setNMType(node_manager_mode);
    cd('/');
    for j in range(number_of_managed_servers_per_machine):
        managed_server_listen_port = managed_server_listen_port_start + j;
        #managed_server_server_name = 'server_' + machine_listen_addresses[i] + '_' + repr(managed_server_listen_port);
        managed_server_server_name = 'server_' + repr(i) + '_' + repr(j);
        if i==0 and j==0:
            print 'ADJUSTING EXISTING MANAGED SERVER' + repr(i) + ',' + repr(j);
            cd('Servers/osb_server1');
            cmo.setName(managed_server_server_name);   
            cmo.setListenPort(managed_server_listen_port);
            cmo.setListenAddress(machine_listen_addresses[i]);
            cmo.setCluster(cluster);
            cmo.setMachine(machine);
            setServerGroups(managed_server_server_name, server_groups);
            assign('Server', managed_server_server_name, 'Cluster', cluster_name);
            cd('/');
        else:
            print 'CREATING SERVER' + repr(i) + ',' + repr(j);
            server = create(managed_server_server_name,'Server');
            server.setListenPort(managed_server_listen_port);
            server.setListenAddress(machine_listen_addresses[i]);
            server.setCluster(cluster);
            server.setMachine(machine);
            setServerGroups(managed_server_server_name, server_groups);
            assign('Server', managed_server_server_name, 'Cluster', cluster_name);
            cd('/');
 
print 'RETARGET JMS RESOURCES';
filestores = cmo.getFileStores();
for filestore in filestores:
    targets = filestore.getTargets();
    for target in targets:
        if ' (migratable)' in target.getName():
            assign('FileStore', filestore.getName(), 'Target', target.getName().strip(' (migratable)'));
jmsservers = cmo.getJMSServers();
for jmsserver in jmsservers:
    targets = jmsserver.getTargets();
    for target in targets:
        if ' (migratable)' in target.getName():
            assign('JMSServer', jmsserver.getName(), 'Target', target.getName().strip(' (migratable)'));
safagents = cmo.getSAFAgents();
for safagent in safagents:
    targets = safagent.getTargets();
    for target in targets:
        if ' (migratable)' in target.getName():
            assign('SAFAgent', safagent.getName(), 'Target', target.getName().strip(' (migratable)'));
 
print 'ADJUST DATA SOURCE SETTINGS';
jdbcsystemresources = cmo.getJDBCSystemResources();
for jdbcsystemresource in jdbcsystemresources:
    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCConnectionPoolParams/NO_NAME_0');
    cmo.setStatementCacheSize(0);
    cmo.setTestConnectionsOnReserve(java.lang.Boolean('false'));
    cmo.setTestTableName(data_source_test);
    cmo.setConnectionCreationRetryFrequencySeconds(30);
    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCDriverParams/NO_NAME_0');
    cmo.setUrl(data_source_url);
    cmo.setPasswordEncrypted(data_source_password);
    #if cmo.getDriverName() == 'oracle.jdbc.xa.client.OracleXADataSource':
    #    print '- CHANGING DRIVER FOR ' + jdbcsystemresource.getName();
    #    cmo.setDriverName(data_source_driver);
    #    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCDataSourceParams/NO_NAME_0');
    #    cmo.setGlobalTransactionsProtocol('LoggingLastResource');
    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCDriverParams/NO_NAME_0/Properties/NO_NAME_0/Property/user');
    cmo.setValue(cmo.getValue().replace('DEV',data_source_user_prefix));
    cd('/');
 
print "SET NODE MANAGER CREDENTIALS";
cd("/SecurityConfiguration/" + domain_name);
cmo.setNodeManagerUsername(node_manager_username);
cmo.setNodeManagerPasswordEncrypted(node_manager_password);
 
print "DISABLE HOSTNAME VERIFICATION";
cd('/Server/' + admin_server_name);
create(admin_server_name,'SSL');
cd('SSL/' + admin_server_name);
cmo.setHostnameVerificationIgnored(true);
cmo.setHostnameVerifier(None);
cmo.setTwoWaySSLEnabled(false);
cmo.setClientCertificateEnforced(false);
 
print "SET UP LDAP CONFIGURATION"
cd('/SecurityConfiguration/'+ domain_name +'/Realms/myrealm');
cd('AuthenticationProviders/DefaultAuthenticator');
set('ControlFlag', 'SUFFICIENT');
cd('../../');
 
print 'SAVE CHANGES';
updateDomain();
closeDomain();
 
print 'CREATE FILES';
directory_name = domain_home + '/servers/'+ admin_server_name +'/security';
file_name = 'boot.properties';
content = 'username=' + admin_username + '\npassword=' + admin_password;
createFile(directory_name, file_name, content);
 
directory_name = domain_application_home;
file_name = 'readme.txt';
content = 'This directory contains deployment files and deployment plans.\nTo set-up a deployment, create a directory with the name of the application.\nSubsequently, create two sub-directories called app and plan.\nThe app directory contains the deployment artifact.\nThe plan directory contains the deployment plan.';
createFile(directory_name, file_name, content);
 
directory_name = node_manager_home;
file_name = 'nodemanager.properties';
if node_manager_mode == 'plain':
    content='DomainsFile=' + node_manager_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + node_manager_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=\nNativeVersionEnabled=true\nListenPort=5556\nLogToStderr=true\nSecureListener=false\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + node_manager_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50';
else:
    content='DomainsFile=' + node_manager_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + node_manager_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=\nNativeVersionEnabled=true\nListenPort=5556\nLogToStderr=true\nSecureListener=true\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + node_manager_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50';
createFile(directory_name, file_name, content);
