#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

# update yum
execute 'yum_update_upgrade' do
	command 'yum update && sudo yum upgrade'
end

# install jdk
jdk_version = node[:tomcat][:jdk_version]
package ['java-1.8.0-openjdk-devel'] do
	action :install
end

# Download tomcat
tomcat_url = node[:tomcat][:tomcat_url]

script "Download Tomcat" do
	interpreter "bash"
	cwd "/tmp"
	code <<-EOH
		wget "#{tomcat_url}"
	EOH
end

# create tomcat user
group "tomcat"
user "tomcat" do
	group "tomcat"
	system true
	shell "/bin/bash"
end

# create tomcat directory
tomcat_install_dir = node['tomcat']['install_dir']
directory "#{tomcat_install_dir}" do
	owner 'tomcat'
	group 'tomcat'
	recursive true
	mode '0755'
	action :create
end

# extract tomcat to target directory

script "Extract Tomcat" do
	interpreter "bash"
	cwd "/tmp"
	user "tomcat"
	group "tomcat"
	code <<-EOH
		tar xvf /tmp/apache-tomcat*.tar.gz -C #{tomcat_install_dir} --strip-components=1
	EOH
end

# copy service file to destination
path_service_file = node[:tomcat][:path_service_file]
template "#{path_service_file}" do
	source 'default.erb'
	owner "tomcat"
	group "tomcat"
	mode '0755'
end

# make tomcat user owner for webapps work temp and logs directory
execute "change owner for directories" do
	cwd "#{tomcat_install_dir}"      
      	command "chown -R tomcat webapps/ work/ temp/ logs/"
	user "root"
	action :run
end

# Reload systemctl daemon
script "Reload Systemctl daemon" do
	interpreter "bash"
	code <<-EOH
		systemctl daemon-reload
	EOH
end


# starttomcat to destination directory
script "Move to destination directory" do
	interpreter "bash"
	code <<-EOH
		#{tomcat_install_dir}/bin/startup.sh
	EOH
end

# ensure tomcat	is started
script "Start Tomcat" do
	interpreter "bash"
	code <<-EOH
		systemctl start tomcat.service
	EOH
end

#ensure tomcat is enabled
script "Enable Tomcat" do
	        interpreter "bash"
        code <<-EOH
                systemctl enable tomcat.service
        EOH
end
