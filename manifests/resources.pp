
class dns::resources {
  
  define direct (
    $zone,
    $host = $name,
    $data,
    $netmask,
    $record = 'A',
    $dns_class = 'IN',
    $ttl = '',
    $preference = false,
    $order = 008
  ) {
  
    include dns::config_os
  
    $zone_file = "$dns::config_os::db_folder/db.${zone}.zone"
  
    $elaborate_data = inline_template('<%= data.split(".").collect {|x| x.rjust(3,"0") } %>' )
    $hoste = $host
    $datae = $data
 
    concat::fragment{"db.${zone}.${elaborate_data}.${name}.record":
      target  => $zone_file,
      order   => $order,
      content => template("${module_name}/zone_record.erb")
    }
  }

  define reverse (
    $zone,
    $host = $name,
    $data,
    $netmask,
    $record = 'PTR',
    $dns_class = 'IN',
    $ttl = '',
    $preference = false,
    $order = 008
  ) {

    include dns::config_os
  
    $zone_file = "$dns::config_os::db_folder/db.${zone}.zone"
  
    $elaborate_data = inline_template('<%= data.split(".").collect {|x| x.rjust(3,"0") } %>' )
    $h3 = inline_template( '<%= data.split(".").last(2).reverse.last %>' )
    $h4 = inline_template( '<%= data.split(".").last(2).last %>' )
    $hoste = "$h4.$h3"
    $datae = "$host."
 
    concat::fragment{"db.${zone}.${elaborate_data}.${name}.record":
      target  => $zone_file,
      order   => $order,
      content => template("${module_name}/zone_record.erb")
    }
  }

}
