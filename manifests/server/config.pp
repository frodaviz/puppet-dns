class dns::server::config {

  file { "$dns::config_os::conf_folder":
    ensure => directory,
    owner  => $dns::config_os::owner_os,
    group  => $dns::config_os::group_os,
    mode   => '0755',
  }

  concat { "$dns::config_os::conf_folder/named1.conf":
    owner   => $dns::config_os::owner_os,
    group   => $dns::config_os::group_os,
    mode    => '0644',
    require => Class['concat::setup'],
    #notify  => Class['dns::server::service']
  }
  concat::fragment{'named.conf.header':
    ensure  => present,
    target  => "$dns::config_os::conf_folder/named1.conf",
    order   => 001,
    content => "#
# File managed by Puppet.
#

#include \"$dns::config_os::conf_folder/named.conf.options\";
#include \"$dns::config_os::conf_folder/named.conf.local\";
#include \"$dns::config_os::conf_folder/named.conf.default-zones\";
"
  }

  concat { "$dns::config_os::conf_folder/named.conf.local":
    owner   => $dns::config_os::owner_os,
    group   => $dns::config_os::group_os,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "$dns::config_os::conf_folder/named.conf.local",
    order   => 001,
    content => "#\n#File managed by Puppet.\n#\n"
  }

}

