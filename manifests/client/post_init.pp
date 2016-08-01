define openafs::client::post_init (
  $fn_post_init = $openafs::client::fn_post_init,
  $order        = 10,
  $content
) {
  if $fn_post_init {
    validate_string($content, $order)
    validate_absolute_path($fn_post_init)

    concat::fragment { "openafs::config::post_init-${name}":
      target  => $fn_post_init,
      order   => $order,
      content => "${content}\n",
    }   
  } else {
    warning('Unsupported AFS post init hooks')
  }
}
