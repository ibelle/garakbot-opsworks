
approot = node['theorder']['approot']
nginx_root= node['nginx']['dir']


#Configure NGINX
##Add Django Config as "default" nginx site
template "#{nginx_root}/sites-available/#{node['theorder']['project_name']}" do
  source "nginx.erb"
  mode 0777
  owner node['theorder']['app_owner']
  group node['theorder']['app_group']
end

link "#{nginx_root}/sites-enabled/#{node['theorder']['project_name']}" do
  to "#{nginx_root}/sites-available/#{node['theorder']['project_name']}"
  not_if "test -L #{nginx_root}/sites-enabled/#{node['theorder']['project_name']}"
end

template "/etc/init/errbot.conf" do
  source "errbot.conf.erb"
  mode 0644
  owner "root"
  group "root"
end