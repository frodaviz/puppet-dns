define dns::record::aaaa (
  $zone,
  $data,
  $ttl = '',
  $host = $name,
  $custom_order = '090' ) {

  $alias = "${host},AAAA,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'AAAA',
    data   => $data,
    order  => $custom_order
  }
}
