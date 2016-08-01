class openafs::client::config::suse (
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
  $_afsdb = $afsdb ? {
    true    => 'yes',
    default => 'no',
  }

  $_crypt = $crypt ? {
    true    => 'yes',
    default => 'no',
  }

  $_dynroot = $dynroot ? {
    true    => 'yes',
    default => 'no',
  }

  $_fakestat = $fakestat ? {
    true    => 'yes',
    default => 'no',
  }

  $_options = $options ? {
    ''      => 'AUTOMATIC',
    default => $options,
  }

  augeas { 'openafs-client':
    lens    => 'Shellvars.lns',
    incl    => '/etc/sysconfig/openafs-client',
    context => '/files/etc/sysconfig/openafs-client/',
    changes => [
      "set REGENERATE_CELL_INFO '\"no\"'", #TODO??
      "set THIS_CELL '\"${this_cell}\"'",
      "set DATA_ENCRYPTION '\"${_crypt}\"'",
      "set REGENERATE_CACHE_INFO '\"no\"'", #TODO?? i.e. /etc/openafs/cacheinfo
      "set DYNROOT '\"${_dynroot}\"'",
      "set FAKESTAT '\"${_fakestat}\"'",
      "set AFSDB '\"${_afsdb}\"'",
      #"set MEMCACHE '\"\"'",
      "set CACHESIZE '\"2097152\"'",  #AUTOMATIC
      "set OPTIONS '\"${_options}\"'",
      "set CACHEDIR '\"${cache_dir}\"'",
      "set AFSDIR '\"${mount_dir}\"'",
    ],
  }
}
