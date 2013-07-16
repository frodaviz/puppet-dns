define dns::record::a (
  $zone,
  $data,
  $ttl = '',
  $ptr = false,
  $host = $name,
  $custom_order = '090' ) {

  $alias = "${name},A,${zone}"

  dns::record { $alias:
    zone  => $zone,
    host  => $host,
    ttl   => $ttl,
    data  => $data,
    order => $custom_order
  }

  if $ptr {
    $ip = inline_template('<%= data.kind_of?(Array) ? data.first : data %>')
    $reverse_zone = inline_template('<%= ip.split(".")[0..-2].reverse.join(".") %>.IN-ADDR.ARPA')
    $octet = inline_template('<%= ip.split(".")[-1] %>')

    notify { "$ip $reverse_zone $octet": }

    dns::record::ptr { $octet:
      zone => $reverse_zone,
      data => "${host}.${zone}"
    }
  }
}
