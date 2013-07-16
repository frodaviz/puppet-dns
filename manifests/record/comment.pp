define dns::record::comment (
  $zone,
  $comment      = '',
  $custom_order = '004',
  $extra_order  = '', 
  $multiline    = false  ) {

  # set alias for concat:fragment
  if $extra_order == '' {
    $alias = "${name},comment,${zone}"
  } else {
    $alias = "$extra_order,${name},comment,${zone}"
  }


  if $multiline == true {
    $maintitle = "\n; $name\n"
    $textcomment = ";   $comment\n"
  }
  elsif $multiline == false {
    $maintitle = "; $name"
    $textcomment = " $comment"
  }

  dns::record { $alias:
    zone  => $zone,
    host  => $maintitle,
    record => "COMMENT",
    ttl   => '',
    data  => $textcomment,
    order => $custom_order
  }
}

