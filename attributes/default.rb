include_attribute "python::default"

override[:graphite][:base_dir] = "/opt/graphite"
default[:graphite][:version] = "0.9.9"
default[:graphite][:python_version] = node[:python][:version].gsub(/^([^\.]*)\.([^\.]+)(\.([^\.]+))$/,'\1.\2')
