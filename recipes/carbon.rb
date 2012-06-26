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
end

execute "install carbon" do
  command "python setup.py install"
  creates "#{node['graphite']['base_dir']}/lib/carbon-#{node['graphite']['version']}-py#{node['graphite']['python_version']}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/carbon-#{node['graphite']['version']}"
end

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
  notifies :restart, "service[carbon-cache]"
end

if node['graphite']['carbon']['storage_schema_search']['enabled']
  filter = node['graphite']['carbon']['storage_schema_search']['filter']
  filter = filter.nil? ? '' : " AND #{filter}"

  search(:node, "graphite_carbon_storage_schemas:*#{filter} AND NOT name:#{node.name}") do |n|
    n['graphite']['carbon']['storage_schemas'].each_pair do |key, value|
      node.override['graphite']['carbon']['storage_schemas'][key] = value
    end
  end
end

template "#{node['graphite']['base_dir']}/conf/storage-schemas.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
  notifies :restart, 'service[carbon-cache]'
end

execute "carbon: change graphite storage permissions to apache user" do
  command "chown -R #{node['apache']['user']}:#{node['apache']['group']} #{node['graphite']['base_dir']}/storage"
  only_if do
    f = File.stat("#{node['graphite']['base_dir']}/storage")
    f.uid == 0 and f.gid == 0
  end
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
end