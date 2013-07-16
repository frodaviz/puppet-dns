class dns::server { 

  include dns::config_os
  include dns::server::install
  include dns::server::config
  include dns::server::service
}

