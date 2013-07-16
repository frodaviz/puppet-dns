define dns::zone (
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
  $slaves  = [],
  $zone_notify = false,
  $ensure = present,
  $comment = '',
  $inverted_network = '',
  $acls  = [],
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
    # Zone Database
    concat { $zone_file:
      owner   => $dns::config_os::owner_os,
      group   => $dns::config_os::group_os,
      mode    => '0644',
      require => [Class['concat::setup'], Class['dns::server']],
      notify  => Class['dns::server::service']
      #
      # named-checkzone 10.18.172.in-addr.arpa db.10.18.172.zone

    }
    concat::fragment{"db.${name}.soa":
      target  => $zone_file,
      order   => 001,
      content => template("${module_name}/zone_file.erb")
    }
    if $comment != '' {
      concat::fragment{"db.comment.${name}.soa":
        target  => $zone_file,
        order   => 005,
        content => "\n;\n; $comment\n;\n\n",
      }
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

  # Import resource
  Dns::Resources::Direct  <<| zone == $title |>>
  Dns::Resources::Reverse <<| zone == $title |>>
}
