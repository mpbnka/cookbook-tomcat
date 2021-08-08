# Tomcat

This cookbook is an attempt to create a initial prototype to install tomcat server on a node. The cookbook assumes that we are using centos version 8 and that http and https and 8080 ports are open on firewall to enable communication from chef server to node. 8080 port to test if the default apache tomcat webpage is available after installation is successful.


# Files

The mail files in this cookbook are default.rb in recipies directory which has the code to install the tomcat server.
The other file is the default.erb file in templates directory which has the tomcat.service file. The values in this file are hardcoded.
Other file being the default.rb in attributes directory that holds the values for attributes being used in recipies/default.rb file.
Please play with "tomcat_url" and "java_install_version" in case this breaks while installing, though it should not as of date.


## Running the Cookbook

Clone the cookbook in your workstation cookbooks directory and upload to chef-server. Add this cookbook to the run list for a desired node.
Please open ports in firewall for http, https and 8080.
Login to your node and run chef-client.
You should be able to access tomcat on port 8080 once the chef-client run is complete.

