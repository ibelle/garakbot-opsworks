default['theorder']['project_name'] = 'garak'

#Git Settings
default['theorder']['repo'] = 'ssh://git@github.com:ibelle/garakbot.git'
default['theorder']['target_branch'] = 'master'

#User/Server Settings
default['theorder']['requirements_file']='requirements-deploy'
default['theorder']['app_owner'] = "theorder"
default['theorder']['app_group'] = "theorder"
default['theorder']['pub_key'] = 'PUB-KEY'

default['theorder']['priv_key'] = 'RSA KEY'

default['theorder']['app_user_home'] = "/home/theorder"

#Global Folders
default['theorder']['global_dirs'] = %w{media static logs}
default['theorder']['approot'] = "/srv/www/garak"


#Project Folders
default['theorder']['garak_project_dir'] = '/srv/www/garak/current'
default['theorder']['project_asset_dir'] = '/srv/www/garak/current/static'
default['theorder']['project_media_dir'] = '/srv/www/garak/current/media'
default['theorder']['project_log_dir'] = '/srv/www/garak/current/logs'
default['theorder']['err_log_dir'] = '/srv/www/garak/current/data/log/err'

#Virtual ENV dirs
default['theorder']['virtualenv_base'] = '/srv/www/garak/current/venv'
default['theorder']['virtualenv_dir'] = 'garak'
