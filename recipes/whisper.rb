remote_file "#{Chef::Config[:file_cache_path]}/whisper-#{node['graphite']['version']}.tar.gz" do
  source node['graphite']['whisper']['package_url']
  action :create_if_missing
end

execute "untar whisper" do
  command "tar xzf whisper-#{node['graphite']['version']}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/whisper-#{node['graphite']['version']}"
  cwd Chef::Config[:file_cache_path]
  action :nothing
  subscribes :run, "remote_file[#{Chef::Config[:file_cache_path]}/whisper-#{node['graphite']['version']}.tar.gz]", :immediately
end

execute "install whisper" do
  command "python setup.py install"
  creates "#{node['python']['pip']['prefix_dir']}/lib/python#{node['graphite']['python_version']}/dist-packages/whisper-#{node['graphite']['version']}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/whisper-#{node['graphite']['version']}"
  action :nothing
  subscribes :run, 'execute[untar whisper]', :immediately
end

directory node['graphite']['base_dir'] do
  owner node['apache']['user']
  group node['apache']['group']
  mode "700"
  recursive true
end

directory "#{node['graphite']['base_dir']}/bin" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "700"
end

execute 'install whisper utils' do
  command "cp #{Chef::Config[:file_cache_path]}/whisper-#{node['graphite']['version']}/bin/* #{node['graphite']['base_dir']}/bin"
  creates "#{node['graphite']['base_dir']}/bin/rrd2whisper.py" # and more
end
