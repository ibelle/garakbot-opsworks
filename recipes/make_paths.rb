#App Root
directory node['theorder']['approot'] do
  		owner node['theorder']['app_owner']
  		group node['theorder']['app_group']
  		mode 00755
  		action :create
      not_if do ::File.exist?(node['theorder']['approot']) end
end

#Shared Dirs
node['theorder']['global_dirs'].each do |path|
  shared_dir = "#{node['theorder']['approot']}/shared/#{path}"
  directory shared_dir do
        owner node['theorder']['app_owner']
        group node['theorder']['app_group']
        mode 00755
        action :create
        recursive true
        not_if do ::File.exist?(shared_dir) end
  end 
end

