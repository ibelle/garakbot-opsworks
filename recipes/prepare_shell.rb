#Add System User and Group
user node['theorder']['app_owner'] do
  system false
  action :create
  supports :manage_home => true
  home "/home/#{node['theorder']['app_owner']}"
  not_if "sudo getent passwd #{node['theorder']['app_owner']}"
end

group node['theorder']['app_group'] do
  system false
  action :create
  members node['theorder']['app_owner']
  not_if "sudo getent passwd #{node['theorder']['app_owner']}"
end


directory "#{node['theorder']['app_user_home']}/.ssh" do
    mode 0700
    owner node['theorder']['app_owner']
    group node['theorder']['app_group']
    action :create
    recursive true
    not_if do ::File.exist?( "#{node['theorder']['app_user_home']}/.ssh" ) end
end


template "/home/#{node['theorder']['app_owner']}/.ssh/id_rsa" do
  source 'private_key.erb'
  mode 0400
  owner node['theorder']['app_owner']
  group node['theorder']['app_group']
  variables(private_key:node['theorder']['priv_key'])
  action :create_if_missing
end

template "/home/#{node['theorder']['app_owner']}/.ssh/id_rsa.pub" do
  source 'public_key.erb'
  mode 0400
  owner node['theorder']['app_owner']
  group node['theorder']['app_group']
  variables(public_key:node['theorder']['pub_key'])
  action :create_if_missing
end


#Install global packages pip, virtualenv and virtualenvwrapper
execute "install_pip" do
  command "sudo apt-get install python-pip -y"
end

execute "install_virtualenv" do
  command "sudo pip install virtualenv"
end

execute "install_virtualenvwrapper" do
  command "sudo pip install virtualenvwrapper"
end

execute "fix_time" do
  command "sudo timedatectl set-timezone America/New_York"
end

execute "fix_missing" do
  command "sudo apt-get update -y --fix-missing"
end

execute "fix_python-mysqldb" do
  command "sudo apt-get install -y python-mysqldb"
end

execute "fix_python-mysqldb-1" do
  command "sudo apt-get install -y libmysqlclient-dev"
end

execute "fix_python-dev" do
  command "sudo apt-get install -y python-dev"
end

execute "fix_python3-dev" do
  command "sudo apt-get install -y python3-dev"
end



execute "fix_python-imgaging" do
  command "sudo apt-get install -y python-imaging"
end

execute "install_jpeglib" do
  command "sudo apt-get install -y libjpeg-dev"
end


execute "install_libffi" do
  command "sudo apt-get install libffi-dev"
end


#Update Bash shell for VirtualEnvWrapper commands
bash "update_bashrc" do
   cwd node['theorder']['app_user_home']
   user node['theorder']['app_owner']
   group node['theorder']['app_group']
   code <<-EOF
   if [ `grep -nc 'WORKON_HOME' .bashrc` == 0 ]; then  echo 'export WORKON_HOME=#{node['theorder']['virtualenv_base']}' >> .bashrc; fi
   if [ `grep -nc 'PROJECT_HOME' .bashrc` == 0 ]; then  echo 'export PROJECT_HOME=#{node['theorder']['garak_project_dir']}' >> .bashrc; fi
   if [ `grep -nc 'DJANGO_SETTINGS_MODULE' .bashrc` == 0 ]; then  echo 'export DJANGO_SETTINGS_MODULE=#{node['theorder']['env_settings']}' >> .bashrc; fi
   if [ `grep -nc 'source  /usr/local/bin/virtualenvwrapper.sh' .bashrc` == 0 ]; then  echo 'source  /usr/local/bin/virtualenvwrapper.sh' >> .bashrc; fi
   EOF
end











