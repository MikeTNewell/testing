# ############################################################
# NAME: buildDomain.py
#
# DESC: Jython WLST script to build domain (cluster, machines
#       managed servers, data sources, and JMS).
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user]: [version] [notes]
# 2014/01/20 cgwong: [v1.0.0] Initial creation
# ############################################################

import socket;

# JMS info
sub_deployment_name = jms_system_resource_name + jms_sub_deployment_name;

# Data Source info
data_source_test = 'SQL SELECT 1 FROM DUAL';

print 'CREATE PATHS';
domain_name = os.getenv('DOMAIN_NAME');
java_home = os.getenv('JAVA_HOME');
mw_home = os.getenv('MW_HOME');
wls_home = os.getenv('WL_HOME');
fmw_home = os.getenv('FMW_HOME');
cfg_home = os.getenv('CFG_BASE');

domain_home=cfg_home + '/domains/' + domain_name;
domain_application_home=cfg_home + '/webapps/' + domain_name;
nm_home=domain_home + '/nodemanager';

def connect_to_admin_server():
  print 'CONNECT TO ADMIN SERVER';
  aserver_listen_address = socket.gethostname();
  aserver_url = 't3://' + aserver_listen_address + ':' + aserver_listen_port;
  connect(aserver_username, aserver_password, aserver_url);

def create_cluster():
  print 'CREATE STANDARD CLUSTER';
  cluster = cmo.createCluster(cluster_name);
  cluster.setClusterMessagingMode('unicast');
  return cluster;

def create_dynamic_cluster():
  print 'CREATE DYNAMIC CLUSTER';
  dcluster = cmo.createCluster(cluster_name);
  dcluster.setClusterMessagingMode('unicast');
  cmo.createServerTemplate(dcluster_template_name);
  server_template = cmo.lookupServerTemplate(dcluster_template_name);
  server_template.setListenPort(dcluster_listen_port_start);
  server_template.setCluster(dcluster);
  dcluster.getDynamicServers().setServerTemplate(server_template);
  dcluster.getDynamicServers().setMaximumDynamicServerCount(mserver_count);
  dcluster.getDynamicServers().setMachineNameMatchExpression(dclust_machine_match);
  dcluster.getDynamicServers().setServerNamePrefix(dclust_mserver_prefix);
  dcluster.getDynamicServers().setCalculatedMachineName(java.lang.Boolean('true'));
  dcluster.getDynamicServers().setCalculatedListenPorts(java.lang.Boolean('true'));
  dcluster.setCluster
  return dcluster;
  
def create_machines_and_servers(cluster):
  print 'CREATE MACHINES AND SERVERS';
  for i in range(len(machine_listen_addresses)):
    try:
      machine = cmo.createUnixMachine(machine_listen_addresses[i]);
      machine.setPostBindUIDEnabled(java.lang.Boolean('true'));
      machine.setPostBindUID(machine_user_id);
      machine.setPostBindGIDEnabled(java.lang.Boolean('true'));
      machine.setPostBindGID(machine_group_id);
      machine.getNodeManager().setListenAddress(machine_listen_addresses[i]);
      machine.getNodeManager().setNMType(nm_mode);
    except java.lang.Exception, e:
      print 'MACHINE ' + machine_listen_addresses[i] + ' already exists and will not be created.'
    for j in range(mserver_per_domain):
      mserver_listen_port = mserver_listen_port_start + j;
      mserver_server_name = 'msvr_' + j + '_' + repr(mserver_listen_port);
      server = cmo.createServer(mserver_server_name);
      server.setListenPort(mserver_listen_port);
      server.setListenAddress(machine_listen_addresses[i]);
      server.setCluster(cluster);
      server.setMachine(machine);	

def create_messaging_resources(targets):
  print 'CREATE JMS SYSTEM MODULE';
  module = cmo.createJMSSystemResource(jms_system_resource_name);
  module_targets = module.getTargets();
  module_targets.append(targets);
  module.setTargets(module_targets);
  module.createSubDeployment(sub_deployment_name);
  resource = module.getJMSResource();

  print 'CREATE CONNECTION FACTORY';
  for i in range(len(connection_factory_names)):
    resource.createConnectionFactory(connection_factory_names[i]);
    connection_factory = resource.lookupConnectionFactory(connection_factory_names[i]);

    connection_factory.setJNDIName(connection_factory_jndi_names[i]);
    connection_factory.setDefaultTargetingEnabled(true);
    connection_factory.getTransactionParams().setTransactionTimeout(3600);
    connection_factory.getTransactionParams().setXAConnectionFactoryEnabled(true);

  print 'CREATE UNIFORM DISTRIBUTED QUEUE';
  for i in range(len(distributed_queue_names)):
    resource.createUniformDistributedQueue(distributed_queue_names[i]);
    distributed_queue = resource.lookupUniformDistributedQueue(distributed_queue_names[i]);
    distributed_queue.setJNDIName(distributed_queue_jndi_names[i]);
    distributed_queue.setLoadBalancingPolicy('Round-Robin');
    distributed_queue.setSubDeploymentName(sub_deployment_name);

    print 'CREATE UNIFORM DISTRIBUTED ERROR QUEUE';
    resource.createUniformDistributedQueue(distributed_error_queue_names[i]);
    distributed_error_queue = resource.lookupUniformDistributedQueue(distributed_error_queue_names[i]);
    distributed_error_queue.setJNDIName(distributed_error_queue_jndi_names[i]);
    distributed_error_queue.setLoadBalancingPolicy('Round-Robin');
    distributed_error_queue.setSubDeploymentName(sub_deployment_name);

    distributed_queue.getDeliveryFailureParams().setRedeliveryLimit(2);
    distributed_queue.getDeliveryFailureParams().setExpirationPolicy('Redirect');
    distributed_queue.getDeliveryFailureParams().setErrorDestination(distributed_error_queue);
    distributed_queue.getDeliveryParamsOverrides().setRedeliveryDelay(120);		

  print 'CREATE FILE STORES AND JMS SERVERS';
  #servers = cmo.getServers();
  #sub_deployment_targets = [];
  #for server in servers:
  #	if (server.getName() != admin_server_name):
  #		file_store = cmo.createFileStore('fstore_' + server.getName());
  #		file_store.setDirectory(domain_application_home);
  #		singleton_target = file_store.getTargets();
  #		singleton_target.append(server);
  #		file_store.setTargets(singleton_target);
  #		jms_server = cmo.createJMSServer('jms_svr_' + server.getName());
  #		jms_server.setPersistentStore(file_store);
  #		jms_server.setTargets(singleton_target);
  #		sub_deployment_targets.append(ObjectName(repr(jms_server.getObjectName())));

  sub_deployment_targets = [];
  file_store = cmo.createFileStore('fstore' + cluster_name);
  file_store.setDirectory(domain_application_home);
  file_store.setTargets(module_targets);
  jms_server = cmo.createJMSServer('jms_svr_' + cluster_name);
  jms_server.setPersistentStore(file_store);
  jms_server.setTargets(module_targets);
  sub_deployment_targets.append(ObjectName(repr(jms_server.getObjectName())));

  cd('/JMSSystemResources/'+ jms_system_resource_name +'/SubDeployments/' + sub_deployment_name);
  set('Targets', jarray.array(sub_deployment_targets, ObjectName));
  cd('/');

def create_data_source(targets):
  print 'CREATE DATA SOURCE';
  data_source = cmo.createJDBCSystemResource(data_source_name);
  data_source_targets = data_source.getTargets();
  data_source_targets.append(targets);
  data_source.setTargets(data_source_targets);

  jdbc_resource = data_source.getJDBCResource();
  jdbc_resource.setName(data_source_name);

  data_source_params = jdbc_resource.getJDBCDataSourceParams();
  names = [data_source_jndi_name];
  data_source_params.setJNDINames(names);
  data_source_params.setGlobalTransactionsProtocol('EmulateTwoPhaseCommit');

  driver_params = jdbc_resource.getJDBCDriverParams();
  driver_params.setUrl(data_source_url);
  driver_params.setDriverName(data_source_driver);
  driver_params.setPassword(data_source_password);
  driver_properties = driver_params.getProperties();
  driver_properties.createProperty('user');
  user_property = driver_properties.lookupProperty('user');
  user_property.setValue(data_source_user);

  connection_pool_params = jdbc_resource.getJDBCConnectionPoolParams();
  connection_pool_params.setTestTableName(data_source_test);
  connection_pool_params.setConnectionCreationRetryFrequencySeconds(3600);
  connection_pool_params.setStatementCacheSize(0);

def create_gridlink_data_source(targets):
  print 'CREATE GRIDLINK DATA SOURCE';
  data_source = cmo.createJDBCSystemResource(data_source_name);
  data_source_targets = data_source.getTargets();
  data_source_targets.append(targets);
  data_source.setTargets(data_source_targets);

  jdbc_resource = data_source.getJDBCResource();
  jdbc_resource.setName(data_source_name);

  data_source_params = jdbc_resource.getJDBCDataSourceParams();
  names = [data_source_jndi_name];
  data_source_params.setJNDINames(names);
  data_source_params.setGlobalTransactionsProtocol('EmulateTwoPhaseCommit');

  driver_params = jdbc_resource.getJDBCDriverParams();
  driver_params.setUrl(data_source_url);
  driver_params.setDriverName(data_source_driver);
  driver_params.setPassword(data_source_password);
  driver_properties = driver_params.getProperties();
  driver_properties.createProperty('user');
  user_property = driver_properties.lookupProperty('user');
  user_property.setValue(data_source_user);

  connection_pool_params = jdbc_resource.getJDBCConnectionPoolParams();
  connection_pool_params.setTestTableName(data_source_test);
  connection_pool_params.setConnectionCreationRetryFrequencySeconds(3600);
  connection_pool_params.setStatementCacheSize(0);

  oracle_params = jdbc_resource.getJDBCOracleParams();
  oracle_params.setFanEnabled(java.lang.Boolean('true'));
  oracle_params.setOnsNodeList(data_source_ons_node_list);
  oracle_params.setOnsWalletFile('');
  oracle_params.unSet('OnsWalletPassword');
  oracle_params.unSet('OnsWalletPasswordEncrypted');
  oracle_params.setActiveGridlink(java.lang.Boolean('true'));

def create_users_and_map_roles():
  print 'START SERVER CONFIG';
  serverConfig();

  print 'CREATE USERS AND MAP ROLES';
  security_realm = cmo.getSecurityConfiguration().getDefaultRealm();
  authentication_provider = security_realm.lookupAuthenticationProvider(authenticator);
  authentication_provider.createUser('employee', 'welcome1', 'an employee');
  authentication_provider.createUser('manager', 'welcome1', 'a manager');
  authentication_provider.createGroup('employees', 'employee group');
  authentication_provider.createGroup('managers', 'manager group');
  authentication_provider.addMemberToGroup('employees', 'employee');
  authentication_provider.addMemberToGroup('managers', 'manager');

  role_mapper = security_realm.lookupRoleMapper('XACMLRoleMapper');
  role_expression = role_mapper.getRoleExpression(None, 'Admin');
  role_mapper.setRoleExpression(None, 'Admin', role_expression + '|Grp(employees)');
  role_expression = role_mapper.getRoleExpression(None, 'Deployer');
  role_mapper.setRoleExpression(None, 'Deployer', role_expression + '|Grp(managers)');

def start_edit_mode():
  print 'START EDIT MODE';
  edit();
  startEdit();

def save_and_active_changes():
  print 'SAVE AND ACTIVATE CHANGES';
  save();
  activate(block='true');

connect_to_admin_server();
start_edit_mode();
cluster = create_cluster();
create_machines_and_servers(cluster);
save_and_active_changes();
start_edit_mode();
create_messaging_resources(cluster);
create_data_source(cluster);
#create_gridlink_data_source(cluster);
save_and_active_changes();
#create_users_and_map_roles();

print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
