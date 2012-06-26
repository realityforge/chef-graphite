include_recipe "apache2::mod_python"

pkgs = value_for_platform(
  ["centos","redhat","fedora", "amazon"] => {
    "default" => ["pycairo-devel", "python-memcached", "rrdtool-python"]
  },
  "default" => ["python-cairo-dev","python-django", "python-django-tagging", "python-memcache", "python-rrdtool"]
)

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

if platform?("centos", "fedora", "redhat", "amazon")
  python_pip 'django' do
    version '1.3'
    action :install
  end
  python_pip 'django-tagging' do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/graphite-web-#{node['graphite']['version']}.tar.gz" do
  source node['graphite']['web']['package_url']
  action :create_if_missing
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{node['graphite']['version']}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/graphite-web-#{node['graphite']['version']}"
  cwd Chef::Config[:file_cache_path]
end

execute "install graphite-web" do
  command "python setup.py install"
  creates "#{node['graphite']['base_dir']}/webapp/graphite_web-#{node['graphite']['version']}-py#{node['graphite']['python_version']}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/graphite-web-#{node['graphite']['version']}"
end

template "#{node['apache']['dir']}/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
  notifies :restart, resources(:service => "apache2")
end

apache_site "000-default" do
  enable false
end

apache_site "graphite"

directory "#{node['graphite']['base_dir']}/storage" do
  owner node['apache']['user']
  group node['apache']['group']
end

directory "#{node['graphite']['base_dir']}/storage/log" do
  owner node['apache']['user']
  group node['apache']['group']
end

%w{ webapp whisper }.each do |dir|
  directory "#{node['graphite']['base_dir']}/storage/log/#{dir}" do
    owner node['apache']['user']
    group node['apache']['group']
  end
end

template "#{node['graphite']['base_dir']}/bin/set_admin_passwd.py" do
  source "set_admin_passwd.py.erb"
  owner node['apache']['user']
  group node['apache']['group']
  mode "755"
end

cookbook_file "#{node['graphite']['base_dir']}/storage/graphite.db" do
  action :create_if_missing
  notifies :run, "execute[set admin password]"
end

raise "Must specify the attribute node['graphite']['web']['password']" unless node['graphite']['web']['password']

execute "set admin password" do
  command "#{node['graphite']['base_dir']}/bin/set_admin_passwd.py root #{node['graphite']['web']['password']}"
  action :nothing
end

file "#{node['graphite']['base_dir']}/storage/graphite.db" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "644"
end
