define :opsworks_deploy_dir do

  directory "#{params[:path]}/shared" do
    group params[:group]
    owner params[:user]
    mode 0770
    action :create
    recursive true
  end

  # create shared/ directory structure
  #Config Directory
  directory "#{params[:path]}/shared/config" do
      group params[:group]
      owner params[:user]
      mode 0775
      action :create
      recursive true
  end
  
  #config/app/etc Directory
  directory "#{params[:path]}/shared/config/app/etc" do
      group params[:group]
      owner params[:user]
      mode 0770
      action :create
      recursive true
  end
  
  #media Directory
  directory "#{params[:path]}/shared/media" do
      group params[:group]
      owner params[:user]
      mode 0775
      action :create
      recursive true
  end
  
  #var Directory
  directory "#{params[:path]}/shared/var" do
      group params[:group]
      owner params[:user]
      mode 0775
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
