define dns::manualzone (
  $soa = "${::fqdn}.",
  $soa_email = "root.${::fqdn}.",
  $serial = false,
  $zone_ttl = '604800',
  $zone_refresh = '604800',
  $zone_retry = '86400',
  $zone_expire = '2419200',
  $zone_minimum = '604800',
  $origin = '',
  $nameservers = [ $::fqdn ],
  $reverse = false,
  $link_file = true,
  $zone_type = 'master',
  $slave_masters = 'undef',
  $source  = '',
  $slaves  = [],
  $zone_notify = false,
  $ensure = present,
  $comment = '',
  $inverted_network = '',
  $acls     = [],
  $updaters = [],
) {

  include dns::config_os

  $zone_file = "$dns::config_os::db_folder/db.${name}.zone"

  $zone_serial = $serial ? {
    false   => inline_template('<%= Time.now.to_i %>'),
    default => $serial
  }

  $zone = $reverse ? {
    true    => "${name}.in-addr.arpa",
    default => $name
  }
 
  # Import file
  #if $source != '' {
  #}


  if $origin == '' {
    $origin_e = "${zone}"
  } else {
    $origin_e = "${origin}"
  }

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } else {
    file { $zone_file:
      source => $source,
      owner   => $dns::config_os::owner_os,
      group   => $dns::config_os::group_os,
      mode    => '0644',
      ensure => present,
    }
  }

  # Include Zone in named.conf.local
  concat::fragment{"named.conf.local.${name}.include":
    ensure  => $ensure,
    #target  => $target_file,
    target  => "$dns::config_os::conf_folder/named.conf.local",
    order   => 002,
    content => template("${module_name}/zone.erb")
  }

}
