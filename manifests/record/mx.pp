define dns::record::mx (
  $zone,
  $data,
  $ttl = '',
  $preference = '0',
  $host = $name,
  $custom_order = '002' ) {

  $alias = "${host},MX,${zone}"

  dns::record { $alias:
    zone       => $zone,
    host       => $host,
    ttl        => $ttl,
    record     => 'MX',
    preference => $preference,
    data       => "${data}.",
    order      => $custom_order
  }
}


