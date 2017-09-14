import pan.xapi
 from cred import get_pan_credentials
  credentials = get_pan_credentials()

   print credentials
    xapi = pan.xapi.PanXapi(**credentials)

     xpath = "/config/devices/entry/network/interface/ethernet"

      #open xml file and read it into a variable called data.
       with open ("sub-int.xml", "r") as myfile:
            data=myfile.read().replace('\n', '')

	     #set the config using the above xpath
	      xapi.set(xpath,element=data)

	       #commit the config. Make sure to add the xml command.
	        xapi.commit('<commit/>')

