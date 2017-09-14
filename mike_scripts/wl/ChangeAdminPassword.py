from java.io import FileInputStream
 
propInputStream = FileInputStream("domainsDetails.properties")
configProps = Properties()
configProps.load(propInputStream)
 
for i in 1,2:
 
    domainName=configProps.get("domain.name."+ str(i))
    adminUrl = configProps.get("domain.admin.url."+ str(i))
    adminUser = configProps.get("domain.admin.username."+ str(i))
    oldAdminPassword = configProps.get("domain.admin.OLD.password."+ str(i))
    newAdminPassword = configProps.get("domain.admin.NEW.password."+ str(i))
    i = i + 1
 
    print '################################################################'
    print '        Chaning the Admin Password for :', domainName
    print '################################################################'
    print ' '
    connect(adminUser,oldAdminPassword,adminUrl)
    cd('/SecurityConfiguration/'+domainName+'/Realms/myrealm/AuthenticationProviders/DefaultAuthenticator')
    cmo.resetUserPassword(adminUser,newAdminPassword)
    print '++++++++++++ +++++++++++ +++++++++++ +++++++++++ +++++++++++ +++++++++++ +++++++++++'
    print '*******  Congrates!!! ', domainName , ' Admin Password Changed Successfully  ********'
    print '++++++++++++ +++++++++++ +++++++++++ +++++++++++ +++++++++++ +++++++++++ +++++++++++'
    print ' '
    disconnect()
    print ' '
    print '####   Connecting Using New Credentials.....    ####'
    print ' '
    connect(adminUser,newAdminPassword,adminUrl)
    print '####   Successfully Connected Using New Credentials !!!!    ####'
    print ' '
    disconnect()

