class dns::server::service {

  service { "$dns::config_os::service_name":
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['dns::server::config'], 
#Exec['Service_Reload'] 
  }

#  exec { 'Service_Reload':
#    command => "$dns::config_os::service_reload reload",
#    path   => "/usr/sbin/:/usr/bin:/bin",
##    onlyif     => "/usr/sbin/named-checkconf $dns::config_os::conf_folder",
#  }
}
