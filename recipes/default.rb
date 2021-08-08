#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

# install jdk
yum_package ['java-1.8.0-openjdk-devel.x86_64', 'wget'] do
	action :install
end

# Download tomcat
tomcat_url = node['tomcat']['url']

script "Download Tomcat" do
	interpreter "bash"
	cwd "/tmp"
	code <<-EOH
		curl "#{tomcat_url}" --output "/tmp/apache-tomcat.tar.gz"
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
	code <<-EOH
		tar -zxvf /tmp/apache-tomcat.tar.gz -C #{tomcat_install_dir} --strip-components=1
	EOH
end

path_service_file = node['tomcat']['path_service_file']
# copy service file to destination
template "#{path_service_file}" do
	source 'service.erb'
	owner 'root'
	group 'root'
	mode '0755'
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
		systemctl start tomcat
	EOH
end

#ensure tomcat is enabled
script "Enable Tomcat" do
	        interpreter "bash"
        code <<-EOH
                systemctl enable tomcat
        EOH
end

