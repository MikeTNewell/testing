# ############################################################
# NAME: expandDomain.py
#
# DESC: Jython WLST script to expand (scale-out) domain 
#       (cluster, machines managed servers, data sources, and JMS).
#
# $HeadURL:  $
# $LastChangedBy: $
# $LastChangedDate: $
# $LastChangedRevision: $
#
# LOG:
# yyyy/mm/dd [user]: [version] [notes]
# 2014/04/16 cgwong: [v1.0.0] Initial creation
# ############################################################

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

print 'CREATE PATHS';
domain_name = os.getenv('DOMAIN_NAME');
java_home = os.getenv('JAVA_HOME');
mw_home = os.getenv('MW_HOME');
wls_home = os.getenv('WL_HOME');
fmw_home = os.getenv('FMW_HOME');
cfg_home = os.getenv('CFG_HOME');

domain_home=cfg_home + '/domains/' + domain_name;
domain_application_home=cfg_home + '/webapps/' + domain_name;
nm_home=domain_home + '/nodemanager';

print 'CREATE FILES';
directory_name = domain_application_home;
file_name = 'readme.txt';
content = 'This directory contains deployment files and deployment plans.\nTo set-up a deployment, create a directory with the name of the application.\nSubsequently, create two sub-directories called app and plan.\nThe app directory contains the deployment artifact.\nThe plan directory contains the deployment plan.';
createFile(directory_name, file_name, content);

directory_name = nm_home;
file_name = 'nodemanager.properties';
if node_manager_mode == 'plain':
	content='DomainsFile=' + nm_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + nm_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=\nNativeVersionEnabled=true\nListenPort=' + nm_listen_port + '\nLogToStderr=true\nSecureListener=false\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + nm_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50';
else:
	content='DomainsFile=' + nm_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + nm_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=\nNativeVersionEnabled=true\nListenPort=' + nm_listen_port + '\nLogToStderr=true\nSecureListener=false\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + nm_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50';
createFile(directory_name, file_name, content);
