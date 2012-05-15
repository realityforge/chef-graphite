include_attribute "graphite::default"

default[:graphite][:web][:package_url] = "http://launchpadlibrarian.net/82112308/graphite-web-#{node[:graphite][:version]}.tar.gz"
default[:graphite][:web][:package_checksum] = "cc78bab7fb26b"
default[:graphite][:web][:password] = nil
default[:graphite][:web][:interface] = node[:ipaddress]
default[:graphite][:web][:host] = node[:fqdn]
default[:graphite][:web][:port] = 80
