include_attribute "graphite::default"

default[:graphite][:carbon][:package_url] = "http://launchpadlibrarian.net/82112362/carbon-#{node[:graphite][:version]}.tar.gz"
default[:graphite][:carbon][:package_checksum] = "b3d42e3b93c09"
default[:graphite][:carbon][:line_receiver][:interface] = "127.0.0.1"
default[:graphite][:carbon][:line_receiver][:port] = 2003
default[:graphite][:carbon][:pickle_receiver][:interface] = "127.0.0.1"
default[:graphite][:carbon][:pickle_receiver][:port] = 2004
default[:graphite][:carbon][:cache_query][:interface] = "127.0.0.1"
default[:graphite][:carbon][:cache_query][:port] = 7002
default[:graphite][:carbon][:storage_schemas] = Mash.new
default[:graphite][:carbon][:storage_schemas][:catchall] =
  {
    :priority => 0,
    :pattern => '^.*',
    :retentions => '10s:6h,1m:7d,10m:5y'
  }
