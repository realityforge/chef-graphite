include_attribute "graphite::default"

default['graphite']['web']['package_url'] = "https://github.com/downloads/graphite-project/graphite-web/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['web']['password'] = nil
default['graphite']['web']['interface'] = node['ipaddress']
default['graphite']['web']['host'] = node['fqdn']
default['graphite']['web']['port'] = 80
default['graphite']['web']['timezone'] = 'America/Chicago'
