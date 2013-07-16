define dns::record::cname (
  $zone,
  $data,
  $ttl = '',
  $host = $name,
  $custom_order = '090' ) {

  $alias = "${host},CNAME,${zone}"

  $qualified_data = $data ? {
    '@'     => $data,
    /\.$/   => $data,
    default => "${data}.${zone}."
  }

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'CNAME',
    data   => $qualified_data,
    order  => $custom_order
  }
}
