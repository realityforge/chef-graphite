include_attribute "graphite::default"

default['graphite']['whisper']['package_url'] = "https://github.com/downloads/graphite-project/whisper/whisper-#{node['graphite']['version']}.tar.gz"
default['graphite']['whisper']['package_checksum'] = "36b5fa9175262"
