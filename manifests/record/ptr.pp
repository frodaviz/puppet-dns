define dns::record::ptr (
  $zone,
  $data,
  $ttl    = '',
  $host   = $name,
  $custom_order = '090' ) {

  $alias = "${host},PTR,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => "${host}.",
    ttl    => $ttl,
    record => 'PTR',
    data   => "${data}",
    order  => $custom_order
  }
}

