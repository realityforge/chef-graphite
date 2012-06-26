include_attribute "python::default"

override['graphite']['base_dir'] = "/opt/graphite"
override['graphite']['storage_dir'] = "/opt/graphite/storage"

default['graphite']['version'] = "0.9.10"
default['graphite']['python_version'] = node['python']['version'].gsub(/^([^\.]*)\.([^\.]+)(\.([^\.]+))$/,'\1.\2')
