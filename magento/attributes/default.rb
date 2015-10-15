#REMOVED FOR NOW. NED TO REVISIT IF THE CURL ISSUE IS AMAZON LINUX SPECIFIC
#normal[:mod_php5_apache2][:packages] = [ 'php5-curl', 'php5-gd', 'php5-cli', 'php5-mysql', 'php5-mcrypt' ]
normal[:opsworks][:deploy_keep_releases] = 3
