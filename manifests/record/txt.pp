define dns::record::txt (
  $zone,
  $data,
  $ttl = '',
  $host = $name,
  $custom_order = '090' ) {

  $alias = "${host},TXT,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'TXT',
    data   => $data,
    order  => $custom_order
  }
}

