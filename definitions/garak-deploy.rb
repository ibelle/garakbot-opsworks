define :garak_deploy do
  virtual_env_base = params[:venv_base_dir]
  deploy_dir = params[:deploy_dir]

  #Create Virtual ENV Path
  directory virtual_env_base do
        owner node['theorder']['app_owner']
        group node['theorder']['app_group']
        mode 00755
        action :create
        not_if do ::File.exist?(virtual_env_base) end
  end 

  #Create Actual Virtual ENV
  virtual_env_dir = "#{virtual_env_base}/#{node['theorder']['virtualenv_dir']}"
  python_virtualenv virtual_env_dir do
      interpreter "python3"
      owner node['theorder']['app_owner']
      group node['theorder']['app_group']
      action :create
  end

  execute "bot_log_dir" do
    user node['theorder']['app_owner']
    group node['theorder']['app_group']
    command "mkdir -p #{node['theorder']['err_log_dir']}"
  end


  #HACK
  bash "update_errbot" do
    cwd deploy_dir
    user "root"
    code <<-EOF
      source #{virtual_env_dir}/bin/activate
      #{virtual_env_dir}/bin/pip3.4 install -r #{node['theorder']['requirements_file']}.txt
      chown -R #{node['theorder']['app_owner']}:#{node['theorder']['app_group']}  #{virtual_env_dir}
      EOF
  end
end
