import socket;
import os.path;
 
print 'CREATE VARIABLES';
domain_application_home = os.getenv('DOMAIN_APPLICATION_HOME');
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
domain_name = os.getenv('DOMAIN_NAME');
fusion_middleware_home = os.getenv('FUSION_MIDDLEWARE_HOME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MIDDLEWARE_HOME');
node_manager_home = os.getenv('NODE_MANAGER_HOME');
weblogic_home = os.getenv('WEBLOGIC_HOME');
 
node_manager_listen_address = socket.gethostname();
 
print 'STARTING NODE MANAGER';
startNodeManager(verbose='true', jvmArgs='-server -Xms256m -Xmx256m -XX:PermSize=128m -XX:MaxPermSize=128m -XX:NewRatio=3 -XX:SurvivorRatio=128 -XX:MaxTenuringThreshold=0 -XX:+UseParallelGC -XX:MaxGCPauseMillis=200 -XX:GCTimeRatio=19 -XX:+UseParallelOldGC -Dweblogic.RootDirectory=/data/app/oracle/config' + domain_configuration_home, NodeManagerHome=node_manager_home, ListenPort=node_manager_listen_port, ListenAddress=node_manager_listen_address);

