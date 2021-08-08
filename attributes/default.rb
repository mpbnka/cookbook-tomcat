default[:tomcat][:jdk_version]= "java-1.8.0-openjdk.x86_64"
default[:tomcat][:tomcat_version]="8.5.20"
default[:tomcat][:install_dir]="/opt/tomcat"
default[:tomcat][:tomcat_url]="https://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.69/bin/apache-tomcat-8.5.69.tar.gz"
default[:tomcat][:tomcat_user]="tomcat" 
default[:tomcat][:tomcat_auto_start]="true" 
default[:tomcat][:java_install_version] = 'java-1.7.0-openjdk-devel'
default[:tomcat][:path_service_file] = '/etc/systemd/system/tomcat.service'
