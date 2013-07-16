# Define: bind::server::conf
#
# ISC BIND server template-based configuration definition.
#
# Parameters:
#  $acls:
#   Hash of client ACLs, name as key and array of config lines. Default: empty
#  $masters:
#   Hash of master ACLs, name as key and array of config lines. Default: empty
#  $listen_on_port:
#   IPv4 port to listen on. Set to false to disable. Default: '53'
#  $listen_on_addr:
#   Array of IPv4 addresses to listen on. Default: [ '127.0.0.1' ]
#  $listen_on_v6_port:
#   IPv6 port to listen on. Set to false to disable. Default: '53'
#  $listen_on_v6_addr:
#   Array of IPv6 addresses to listen on. Default: [ '::1' ]
#  $forwarders:
#   Array of forwarders IP addresses. Default: empty
#  $directory:
#   Base directory for the BIND server. Default: '/var/named'
#  $version:
#   Version string override text. Default: none
#  $dump_file:
#   Dump file for the server. Default: '/var/named/data/cache_dump.db'
#  $statistics_file:
#   Statistics file for the server. Default: '/var/named/data/named_stats.txt'
#  $memstatistics_file:
#   Memory statistics file for the server.
#   Default: '/var/named/data/named_mem_stats.txt'
#  $allow_query:
#   Array of IP addrs or ACLs to allow queries from. Default: [ 'localhost' ]
#  $recursion:
#   Allow recursive queries. Default: 'yes'
#  $dnssec_enable:
#   Enable DNSSEC support. Default: 'yes'
#  $dnssec_validation:
#   Enable DNSSEC validation. Default: 'yes'
#  $dnssec_lookaside:
#   DNSSEC lookaside type. Default: 'auto'
#  $zones:
#   Hash of managed zones and their configuration. The key is the zone name
#   and the value is an array of config lines. Default: empty
#  $includes:
#   Array of absolute paths to named.conf include files. Default: empty
#
# Sample Usage :
#  bind::server::conf { '/etc/named.conf':
#      acls => {
#          'rfc1918' => [ '10/8', '172.16/12', '192.168/16' ],
#      },
#      masters => {
#          'mymasters' => [ '192.0.2.1', '198.51.100.1' ],
#      },
#      zones => {
#          'example.com' => [
#              'type master',
#              'file "example.com"',
#          ],
#          'example.org' => [
#              'type slave',
#              'file "slaves/example.org"',
#              'masters { mymasters; }',
#          ],
#      }
#  }
#



define dns::server::file (
    $acls               = {},
    $updaters           = {},
    $masters            = {},
    $listen_on_port     = '53',
    $listen_on_addr     = [ '127.0.0.1' ],
    $listen_on_v6_port  = '53',
    $listen_on_v6_addr  = [ '::1' ],
    $forwarders         = [],
    $directory          = $dns::config_os::db_folder,
    $version            = false,
    $dump_file          = "$dns::config_os::db_folder/data/cache_dump.db",
    $statistics_file    = "$dns::config_os::db_folder/data/named_stats.txt",
    $memstatistics_file = "$dns::config_os::db_folder/data/named_mem_stats.txt",
    $allow_query        = [ 'localhost' ],
    $allow_query_cache  = [],
    $recursion          = 'yes',
    $allow_recursion    = [],
    $dnssec_enable      = 'yes',
    $dnssec_validation  = 'yes',
    $dnssec_lookaside   = 'auto',
    $zones              = {},
    $includes           = [],
    $log_path           = '',
    $log_channels       = { 
'main_log' => [ 
  "file $log_path/main.log versions 5 size 40M",
  "severity info",
  "print-time yes",
  "print-category yes",
  "print-severity yes",
],

'queries_log' => [
  "file $log_path/queries.log versions 5 size 40M",
  'severity warning'], 
},
    $log_category       = { 
      'default' => 'main_log',
      'queries' => 'null', },
#    $log_severity       = 'info',
) {

  include dns::config_os

  file { "$title":
    ensure  => present,
    owner   => $dns::config_os::owner_os,
    group   => $dns::config_os::group_os,
    mode    => '0644',
#    require => [File["$dns::server::conf_folder"], Class['dns::server::install']],
    notify  => Class['dns::server::service'],
    content => template('dns/named.file.erb'),
  }

#  concat { "$dns::config_os::conf_folder/named.config":
#    owner   => $dns::config_os::owner_os,
#    group   => $dns::config_os::group_os,
#    mode    => '0644',
#    require => Class['concat::setup'],
#    notify  => Class['dns::server::service']
#  }

  concat::fragment{"named.conf.$title":
    ensure  => present,
    target  => "$dns::config_os::conf_folder/named1.conf",
    order   => 099,
    content => "\ninclude \"$title\";"
  }

}

