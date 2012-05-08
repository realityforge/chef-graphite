package "python-twisted"
package "python-simplejson"

version = node[:graphite][:version]
pyver = node[:graphite][:python_version]

remote_file "/usr/src/carbon-#{version}.tar.gz" do
  source node[:graphite][:carbon][:uri]
  checksum node[:graphite][:carbon][:checksum]
end

execute "untar carbon" do
  command "tar xzf carbon-#{version}.tar.gz"
  creates "/usr/src/carbon-#{version}"
  cwd "/usr/src"
end

execute "install carbon" do
  command "python setup.py install"
  creates "#{node[:graphite][:base_dir]}/lib/carbon-#{version}-py#{pyver}.egg-info"
  cwd "/usr/src/carbon-#{version}"
end

template "#{node[:graphite][:base_dir]}/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
  notifies :restart, "service[carbon-cache]"
end

template "#{node[:graphite][:base_dir]}/conf/storage-schemas.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "600"
  notifies :restart, 'service[carbon-cache]'
end

execute "carbon: change graphite storage permissions to apache user" do
  command "chown -R #{node['apache']['user']}:#{node['apache']['group']} #{node[:graphite][:base_dir]}/storage"
  only_if do
    f = File.stat("#{node[:graphite][:base_dir]}/storage")
    f.uid == 0 and f.gid == 0
  end
end

directory "#{node[:graphite][:base_dir]}/lib/twisted/plugins/" do
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