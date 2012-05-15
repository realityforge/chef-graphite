include_attribute "graphite::default"

default[:graphite][:whisper][:package_url] = "http://launchpadlibrarian.net/82112367/whisper-#{node[:graphite][:version]}.tar.gz"
default[:graphite][:whisper][:package_checksum] = "66c05eafe8d86"
