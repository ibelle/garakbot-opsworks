include_recipe 'deploy'

#node['deploy'].each do |application, deploy|
=begin
 execute "restart err" do
    cwd deploy['current_path']
    command "sleep #{deploy['sleep_before_restart']} && #{deploy['restart_command']}"
    action :run
    
    only_if do 
      ::File.exists?(deploy['current_path'])
    end 
    notifies :restart, "service[nginx]"
  end
=end
 service "errbot" do
   provider Chef::Provider::Service::Upstart
   enabled true
   running true
   supports :restart => true, :reload => true, :status => true
   action [:enable, :start]
   notifies :restart, "service[nginx]"
 end

 service 'nginx' do
    supports :status => true, :restart => true, :reload => true
    action :restart
  end
#end