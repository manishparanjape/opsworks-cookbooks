#
# Cookbook Name:: deploy
# Recipe:: php
#

include_recipe 'deploy'
include_recipe "mod_php5_apache2"
include_recipe "mod_php5_apache2::php"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::php application #{application} as it is not an PHP app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end
  
  #Mount NFS Server
  execute '' do
    command "mount 172.31.31.12:/public /srv/www/magento/shared"
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
  
  #Fix permisisons Later ....
  #config/app/etc Directory
  directory "#{deploy[:deploy_to]}/current/app/etc" do
      group params[:group]
      owner params[:user]
      mode 0777
      action :create
      recursive true
  end
  
  #var Directory
  directory "#{deploy[:deploy_to]}/current/var" do
      group params[:group]
      owner params[:user]
      mode 0777
      action :create
      recursive true
  end
  
  # Protect var directory with .htaccess
 execute '' do
    command "echo 'Order deny,allow' > #{params[:path]}/shared/var/.htaccess"
 end
 execute '' do
    command "echo 'Deny from all' >> #{params[:path]}/shared/var/.htaccess"
 end
 
end

