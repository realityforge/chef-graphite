package "python-twisted"
package "python-simplejson"

remote_file "/usr/src/carbon-#{node[:graphite][:version]}.tar.gz" do
  source node[:graphite][:carbon][:package_url]
  checksum node[:graphite][:carbon][:package_checksum]
end

execute "untar carbon" do
  command "tar xzf carbon-#{node[:graphite][:version]}.tar.gz"
  creates "/usr/src/carbon-#{node[:graphite][:version]}"
  cwd "/usr/src"
end

execute "install carbon" do
  command "python setup.py install"
  creates "#{node[:graphite][:base_dir]}/lib/carbon-#{node[:graphite][:version]}-py#{node[:graphite][:python_version]}.egg-info"
  cwd "/usr/src/carbon-#{node[:graphite][:version]}"
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