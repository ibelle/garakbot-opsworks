
#1)create timestamp folder under APP_BASE/deploy folder capistrano style
#
#2)create softlinks to global shared folders
#
#3)run Django Updates in deployment folder:
# => activate virtual env
# => pip install dependencies
# => syncdb
# => collect static assets
# => create admin user(if they do not exists)***    
#
#4)restart gunicorn
#
#5)restart nginx
#
#6)clean up old deployments (leaving only current one and the previous one)
deploy_branch node['theorder']['approot'] do
  repo node['theorder']['repo']
  branch node['theorder']['target_branch'] # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user node['theorder']['app_owner']
  action :deploy # or :rollback
  create_dirs_before_symlink  node['theorder']['global_dirs']
  migrate false
  #symlink_before_migrate {"media" => "media", "static" => "static"}
  symlink_before_migrate nil
  symlinks ("media" => "media", 
            "static" => "static", 
            "log"=>"log"
            )
  before_symlink do 
    current_release = release_path
    virtual_env_base = "#{current_release}/venv"
    #Do a bunch of Pythony stuff here 
    #Create Virtual ENV Path
    directory virtual_env_base do
        owner node['theorder']['app_owner']
        group node['theorder']['app_group']
        mode 00755
        action :create
        not_if do ::File.exist?(virtual_env_base) end
    end 
    #Create Virtual ENV
    virtual_env_dir = "#{virtual_env_base}/#{node['theorder']['virtualenv_dir']}"
    python_virtualenv virtual_env_dir do
      interpreter "python3"
      owner node['theorder']['app_owner']
      group node['theorder']['app_group']
      action :create
    end
    bash "update_garak" do
      cwd current_release
      user node['theorder']['app_owner']
      group node['theorder']['app_group']
      code <<-EOF
       source #{virtual_env_dir}/bin/activate
        #{virtual_env_dir}/bin/pip3.4 install -r #{node['theorder']['requirements_file']}.txt
      EOF
    end
  end



  #Restart
  keep_releases 2
  restart_command "sudo initctl stop errbot && sudo initctl start errbot"
  scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
end