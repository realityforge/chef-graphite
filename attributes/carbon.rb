include_attribute "graphite::default"

default['graphite']['carbon']['package_url'] = "https://github.com/downloads/graphite-project/carbon/carbon-#{node['graphite']['version']}.tar.gz"
default['graphite']['carbon']['line_receiver']['interface'] = "127.0.0.1"
default['graphite']['carbon']['line_receiver']['port'] = 2003
default['graphite']['carbon']['pickle_receiver']['interface'] = "127.0.0.1"
default['graphite']['carbon']['pickle_receiver']['port'] = 2004
default['graphite']['carbon']['cache_query']['interface'] = "127.0.0.1"
default['graphite']['carbon']['cache_query']['port'] = 7002
default['graphite']['carbon']['storage_schemas'] = [
  {
    'key' => 'catchall',
    'pattern' => '^.*',
    'retentions' => '10s:6h,1m:7d,10m:60d'
  }
]
default['graphite']['carbon']['storage_aggregations'] = Array.new
