# ===== wlsDomainCreationAndConfiguration.py - Crisp Code =======
 
windows = false;
 
pathSeparator = '\\';
if not windows:
    pathSeparator = '/';
 
domainLocation = '';
jvmLocation = '';
domainTemplate = '';
 
def intialize():
    global domainLocation;
    global jvmLocation;
    global domainTemplate;
 
    print 'Starting the initialization process';
    # Update the path
    loadProperties("Path/To/PropFile/wlsDomainCreationAndConfiguration.properties");
 
    domainLocation = domainsDirectory + pathSeparator + domainName;
    print 'Domain Location: ' + domainLocation;
 
    if len(jvmLocation) == 0:
        jvmLocation = middleWareHome + pathSeparator + 'jrockit_160_24_D1.1.2-4';
    print 'JVM Location: ' + jvmLocation;
 
    # Using Domain Template - wls.jar
    domainTemplate = middleWareHome + pathSeparator + 'wlserver_10.3' + pathSeparator + 'common' + pathSeparator + 'templates' + pathSeparator + 'domains' + pathSeparator + 'wls.jar';
    print 'Using Domain Template: ' + domainTemplate;
 
    print 'Initialization completed';
 
def configureAdminServer():
    print 'Starting Admin Server Configuration...';
 
    print 'Setting listen address/port...';
    cd('/')
    cd('Server/AdminServer')
    cmo.setListenAddress(listenAddress)
    cmo.setListenPort(int(listenPort))
 
    print 'SSL Settings...';
    create('AdminServer','SSL')
    cd('SSL/AdminServer')
    set('Enabled', enableSSL)
    set('ListenPort', int(sslListenPort))
 
    print 'Setting the username/password...';
    cd('/');
    cd('Security/base_domain/User/weblogic');
    cmo.setName(adminUserName);
    cmo.setPassword(adminPassword);
    print 'Admin Server Configuration Completed.';
 
def setStartupOptions():
    print('Setting StartUp Options...');
    setOption('CreateStartMenu', 'false');
    setOption('ServerStartMode', domainMode);
    setOption('JavaHome', jvmLocation);
    setOption('OverwriteDomain', 'false');
 
def createCustomDomain():
    print 'Creating the domain...';
    readTemplate(domainTemplate);
 
    configureAdminServer();
    setStartupOptions();
 
    writeDomain(domainLocation);
    closeTemplate();
    print 'Domain Created';
 
def startAndConnnectToAdminServer():
    connUri = 't3://localhost:%s' % listenPort
    print 'Connection URI : ' + connUri;
 
    print 'Starting the Admin Server...';
    startServer('AdminServer', domainName , connUri, adminUserName, adminPassword, domainLocation,'true',60000,'false');
    print 'Started the Admin Server';
 
    print 'Connecting to the Admin Server';
    connect(adminUserName, adminPassword, 't3://localhost:%s' % listenPort);
    print 'Connected';
 
def shutdownAndExit():
    print 'Shutting down the Admin Server...';
    shutdown();
    print 'Exiting...';
    exit();
 
def deployApplication():
    print 'Starting in edit mode..';
    edit();
    startEdit();
 
    print 'Deploying the ear..';
    deploy('MyApp01', path=appToDeploy);
    print 'Deployment completed';
 
    save();
    activate();
 
# ================================================================
#           Main Code Execution
# ================================================================
 
intialize();
createCustomDomain();
startAndConnnectToAdminServer();
deployApplication();
shutdownAndExit();
# =========== End Of Script ===============

