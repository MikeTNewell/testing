import sys
from java.lang import System

print "@@@ Starting the script ..."
url = 't3://localhost:7001'
usr = 'weblogic'
password = 'weblogic'
connect(usr,password, url)

edit()
startEdit()

print("----------------------------1")
print("*** Creating JDBC DataSource ")
myResourceName = "TestDSA"
print("Here is the Resource Name: " + myResourceName)

print("----------------------------2")
jdbcSystemResource = create(myResourceName,"JDBCSystemResource")
myFile = "TestDSA.xml"
print ("HERE IS THE JDBC FILE NAME: " + myFile)
jdbcResource = jdbcSystemResource.getJDBCResource()
jdbcResource.setName("MyJdbcResource")

print("----------------------------3")
# Create the DataSource Params
dpBean = jdbcResource.getJDBCDataSourceParams()
myName="MyJNDINameA"
dpBean.setJNDINames([myName])

print("----------------------------4")
# Create the Driver Params
drBean = jdbcResource.getJDBCDriverParams()
drBean.setPassword("{3DES}IQHx+vYPxQI5k1W1Dbwubw==")
drBean.setUrl("jdbc:pointbase:server://localhost/demo")
drBean.setDriverName("com.pointbase.jdbc.jdbcUniversalDriver")

print("----------------------------5")
propBean = drBean.getProperties()
driverProps = Properties()
driverProps.setProperty("user","PBPUBLIC")

print("----------------------------6")
e = driverProps.propertyNames()
while e.hasMoreElements() :
propName = e.nextElement()
myBean = propBean.createProperty(propName)
myBean.setValue(driverProps.getProperty(propName))

print("----------------------------7")
save()
activate()
--------------------------------------------------
