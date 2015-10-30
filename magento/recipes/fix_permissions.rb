
node[:deploy].each do |application, deploy|

  app_basepath="#{deploy[:deploy_to]}/current/"
  shared_basepath="/srv/www/#{application}/shared/"
  
  #Mount NFS Server
  execute 'Mount NFS Server' do
    Chef::Log.debug("NFS Server IP is #{node[:nfs][:server_ip]}")
    command "mount 172.31.31.12:/nfsmount/rug/ /srv/www/magento/shared"
  end
  
  #Copy local.xml from shared
  execute 'Copy local.xml' do
    command "cp /srv/www/magento/shared/config/local.xml /srv/www/magento/current/app/etc/local.xml"
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
 file "#{deploy[:deploy_to]}/current/var/.htaccess" do
    content 'Order deny,allow\nDeny from all'
    group params[:group]
    owner params[:user]
    mode 0750
    action :create_if_missing
 end   
 
#  execute "Change owner for #{application}" do
#    user "root"
#    command "chown -R deploy:#{node[:apache][:user]} #{app_basepath}"
#    action :run
#  end
#  
#  execute "Making tools executable in #{app_basepath}tools" do
#    user "root"
#    command "find -L #{app_basepath}tools -type f -exec chmod 775 {} \\;"
#    action :run
#  end
#  
#  execute "Change project file permissions for #{application}" do
#    user "root"
#    command "find #{app_basepath} -type f -exec chmod 664 {} \\;"
#    action :run
#  end
#  
#  execute "Change project directory permissions for #{application}" do
#    user "root"
#    command "find #{app_basepath} -type d -exec chmod 775 {} \\;"
#    action :run
#  end
#
#  %w(media var).each do |name|
#    execute "Change owner for #{shared_basepath}#{name}" do
#      user "root"
#      command "chown -R deploy:#{node[:apache][:user]} #{shared_basepath}#{name}"
#      action :run
#    end
#    execute "Change project file permissions for #{shared_basepath}#{name}" do
#      user "root"
#      command "find #{shared_basepath}#{name} -type f -exec chmod 664 {} \\;"
#      action :run
#    end
#    execute "Change project directory permissions for #{shared_basepath}#{name}" do
#      user "root"
#      command "find #{shared_basepath}#{name} -type d -exec chmod 775 {} \\;"
#      action :run
#    end
#  end  
 
end
