class dns::server::install {

  package { "$dns::config_os::package_name":
    ensure => latest,
  }
}
