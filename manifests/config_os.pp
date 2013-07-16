class dns::config_os {

  case $operatingsystem {
    Debian,Ubuntu: {
      $package_name   = 'bind9'
      $service_name   = 'bind9'
      $service_reload = 'rndc'
      $conf_folder    = '/etc/bind'
      $db_folder      = '/etc/bind'
      $owner_os       = 'bind'
      $group_os       = 'bind'
    }
    CentOS: {
      $package_name   = 'bind'
      $service_name   = 'named'
      $service_reload = 'rndc'
      $conf_folder    = '/etc/named'
      $db_folder      = '/var/named'
      $owner_os       = 'named'
      $group_os       = 'named'
    }
    default: { notice "Unsupported operatingsystem ${operatingsystem}" }
  }

  include concat::setup

}
