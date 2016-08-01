class openafs::client::config::debian (
  $enabled,
  $afsdb,
  $crypt,
  $dynroot,
  $fakestat,
  $options,
  $mount_dir,
  $cache_dir,
  $cacheinfo,
  $export_cell,
  $this_cell,
  $these_cells,
  $post_init,
  $pam_afs_session_args,
  $fn_this_cell,
  $fn_these_cells,
  $fn_cacheinfo,
  $fn_post_init
) {
  file { '/etc/openafs/afs.conf.client':
    content => template('openafs/afs.conf.client.erb'),
  }

  # not perfect, but works
  ini_setting { 'AFS_POST_INIT':
    ensure  => present,
    path    => '/etc/openafs/afs.conf',
    section => '',
    setting => 'AFS_POST_INIT',
    value   => $fn_post_init,
  }

  # not perfect as well, but works
  $_options = $options ? {
    ''      => 'AUTOMATIC',
    default => regsubst($options, "'", "'\\\\''", 'G') # ' -> '\''
  }

  ini_setting { 'OPTIONS':
    ensure  => present,
    path    => '/etc/openafs/afs.conf',
    section => '',
    setting => 'OPTIONS',
    value   => "'${_options}'",
  }

  #TODO: other platforms
  pam { 'session pam_afs_session.so':
    ensure    => present,
    service   => 'common-session',
    type      => 'session',
    control   => 'optional',
    module    => 'pam_afs_session.so',
    arguments => $pam_afs_session_args,
  }
}
