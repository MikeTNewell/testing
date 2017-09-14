current_app_name = '[your current deployed app name]'
new_app_name = '[your new app name]'
target_name = '[WL managed server name (or AdminServer)]'
connect([username],[pwd],'t3://[admin server hostname/IP address]:[PORT]')  
stopApplication(current_app_name)
undeploy(current_app_name, timeout=60000);
war_path = '[path to war file]'
deploy(appName=new_app_name, path=war_path, targets=target_name);

