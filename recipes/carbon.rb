package "python-twisted"
package "python-simplejson"

remote_file "#{Chef::Config[:file_cache_path]}/carbon-#{node['graphite']['version']}.tar.gz" do
  source node['graphite']['carbon']['package_url']
  action :create_if_missing
end

execute "untar carbon" do
  command "tar xzf carbon-#{node['graphite']['version']}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/carbon-#{node['graphite']['version']}"
  cwd Chef::Config[:file_cache_path]
  action  :nothing
  subscribes :run, "remote_file[#{Chef::Config[:file_cache_path]}/carbon-#{node['graphite']['version']}.tar.gz]", :immediately
end

execute "install carbon" do
  command "python setup.py install"
  creates "#{node['graphite']['base_dir']}/lib/carbon-#{node['graphite']['version']}-py#{node['graphite']['python_version']}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/carbon-#{node['graphite']['version']}"
  action :nothing
  subscribes :run, 'execute[untar carbon]', :immediately
end

# Graphite. Sometimes your releases are just plain bad.
if node['graphite']['version'] == '0.9.10'
  execute "patch_broken_graphite_file" do
    command <<CMD
sed -e 's/InvalidConfiguration/Exception/' #{node['graphite']['base_dir']}/lib/carbon/storage.py > #{node['graphite']['base_dir']}/lib/carbon/storage.py.bak
mv #{node['graphite']['base_dir']}/lib/carbon/storage.py.bak #{node['graphite']['base_dir']}/lib/carbon/storage.py
CMD
  end
end

default_whisper_data_dir = "#{node['graphite']['storage_dir']}/whisper"
whisper_data_dir = node['graphite']['whisper']['data_dir']

if default_whisper_data_dir != whisper_data_dir
  unless ::File.symlink?(default_whisper_data_dir)
    directory default_whisper_data_dir do
      action :delete
      recursive true
    end
  end
  directory whisper_data_dir do
    owner node['apache']['user']
    group node['apache']['group']
    mode "0700"
    recursive true
  end
  link default_whisper_data_dir do
    to whisper_data_dir
    owner node['apache']['user']
    group node['apache']['group']
  end
end

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
end

template "#{node['graphite']['base_dir']}/conf/storage-schemas.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
end

template "#{node['graphite']['base_dir']}/conf/storage-aggregation.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
end

directory "#{node['graphite']['base_dir']}/lib/twisted/plugins/" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "700"
end

template "/etc/init.d/carbon-cache" do
  owner "root"
  group "root"
  mode "0755"
  source "carbon.init.erb"
end

service "carbon-cache" do
  action :enable
  subscribes :restart, resources("template[#{node['graphite']['base_dir']}/conf/carbon.conf]"), :delayed
end
