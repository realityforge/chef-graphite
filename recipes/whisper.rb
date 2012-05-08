version = node[:graphite][:version]
pyver = node[:graphite][:python_version]

remote_file "/usr/src/whisper-#{version}.tar.gz" do
  source node[:graphite][:whisper][:uri]
  checksum node[:graphite][:whisper][:checksum]
end

execute "untar whisper" do
  command "tar xzf whisper-#{version}.tar.gz"
  creates "/usr/src/whisper-#{version}"
  cwd "/usr/src"
end

execute "install whisper" do
  command "python setup.py install"
  creates "/usr/local/lib/python#{pyver}/dist-packages/whisper-#{version}.egg-info"
  cwd "/usr/src/whisper-#{version}"

directory "#{node[:graphite][:base_dir]}" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "700"
  recursive true
end

directory "#{node[:graphite][:base_dir]}/bin" do
  owner node['apache']['user']
  group node['apache']['group']
  mode "700"
end

execute 'install whisper utils' do
  command "cp /usr/src/whisper-#{version}/bin/* #{node[:graphite][:base_dir]}/bin"
  creates "#{node[:graphite][:base_dir]}/bin/rrd2whisper.py" # and more
end
