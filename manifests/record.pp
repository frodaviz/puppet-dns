define dns::record (
  $zone,
  $host,
  $data,
  $record = 'A',
  $dns_class = 'IN',
  $ttl = '',
  $preference = false,
  $order = 090
) {

  include dns::config_os

  $zone_file ="$dns::config_os::db_folder/db.${zone}.zone"

  if "$record" == "PTR" {
    $elaborate_data = inline_template( '<%= host.split(".").collect {|x| x.rjust(3,"0") } %>' )
    $h3 = inline_template( '<%= data.split(".").last(2).reverse.last %>' )
    $h4 = inline_template( '<%= data.split(".").last(2).last %>' )
    $hoste = "$h4.$h3"
    $datae    = $host
  } else {
    $hoste    = $host
    $datae    = $data
  }

  #$elaborate = inline_template('<%=  puts data.split(".")    %>')
  #$elaborate = inline_template('<%= data.split(".").reverse.drop(1)  %>') 
  #$elaborate = inline_template('<%= data.split(".").reverse.first  %>')
  #$elaborate = inline_template('<%= data.split(".").reverse.join(".")  %>')
  #$elaborate = inline_template('<%= data.split(".").last  %>')

  if "$record" == "COMMENT" {
    concat::fragment{"db.${zone}.${title}.record":
      target  => $zone_file,
      order   => $order,
      content => template("${module_name}/zone_comment.erb")
     } 
  } else {
    concat::fragment{"db.${zone}.${elaborate_data}.${title}.record":
      target  => $zone_file,
      order   => $order,
      content => template("${module_name}/zone_record.erb")
     }
  }
}
