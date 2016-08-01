class openafs::client (
  $ensure               = $openafs::params::ensure,
  $packages             = $openafs::params::client_packages,
  $packages_kmod        = $openafs::params::client_packages_kmod,
  $apt_release          = $openafs::params::apt_release,
  $apt_version          = $openafs::params::apt_version,
  $own_repo_class       = $openafs::params::own_repo_class,

  $service              = $openafs::params::client_service,
  $hasrestart           = $openafs::params::client_service_hasrestart,
  $hasstatus            = $openafs::params::client_service_hasstatus,
  $pattern              = $openafs::params::client_service_pattern,

  $enabled              = $openafs::params::client_enabled, #TODO
  $afsdb                = $openafs::params::client_afsdb,
  $crypt                = $openafs::params::client_crypt,
  $dynroot              = $openafs::params::client_dynroot,
  $fakestat             = $openafs::params::client_fakestat,
  $options              = $openafs::params::client_options,
  $mount_dir            = $openafs::params::client_mount_dir,
  $cacheinfo            = $openafs::params::client_cacheinfo,
  $export_cell          = $openafs::params::client_export_cell,
  $this_cell            = $openafs::params::client_this_cell,
  $these_cells          = $openafs::params::client_these_cells,
  $post_init            = $openafs::params::client_post_init,
  $pam_afs_session_args = $openafs::params::client_pam_afs_session_args,
  $require_class        = $openafs::params::client_require_class,
  $config_class         = $openafs::params::client_config_class,
  $cache_dir            = $openafs::params::cache_dir,
  $fn_this_cell         = $openafs::params::fn_this_cell,
  $fn_these_cells       = $openafs::params::fn_these_cells,
  $fn_cell_serv_db      = $openafs::params::fn_cell_serv_db,
  $cell_serv_db_source  = $openafs::params::client_cell_serv_db_source,
  $fn_cacheinfo         = $openafs::params::fn_cacheinfo,
  $fn_post_init         = $openafs::params::fn_post_init
) inherits openafs::params {

  validate_bool($enabled, $afsdb, $crypt, $dynroot, $fakestat)
  validate_bool($export_cell)
  validate_bool($hasrestart, $hasstatus)
  validate_string($pattern)
  validate_array($packages, $packages_kmod, $these_cells)
  validate_string($service, $apt_release, $own_repo_class)
  validate_string($require_class, $options, $mount_dir, $cacheinfo)
  validate_string($this_cell, $post_init, $config_class, $cache_dir)
  validate_absolute_path($fn_this_cell, $fn_these_cells, $fn_cell_serv_db)
  validate_string($cell_serv_db_source)
  validate_absolute_path($fn_cacheinfo)

  if $fn_post_init {
    validate_absolute_path($fn_post_init)
  }

  unless is_string($pam_afs_session_args) or is_array($pam_afs_session_args) {
    fail('$pam_afs_session_args must be string or array')
  }

  unless is_string($apt_version) or $apt_version == false {
    fail('$apt_version must be string or false')
  }

  unless $ensure in [present,absent,latest] {
    fail("Invalid ensure state: ${ensure}")
  }

  #####

  if $require_class {
    require $require_class
  }

  class { 'openafs::client::install':
    ensure         => $ensure,
    packages       => $packages,
    packages_kmod  => $packages_kmod,
    apt_release    => $apt_release,
    own_repo_class => $own_repo_class,
  }

  class { 'openafs::client::config':
    enabled              => $enabled,
    afsdb                => $afsdb,
    crypt                => $crypt,
    dynroot              => $dynroot,
    fakestat             => $fakestat,
    options              => $options,
    mount_dir            => $mount_dir,
    cache_dir            => $cache_dir,
    cacheinfo            => $cacheinfo,
    export_cell          => $export_cell,
    this_cell            => $this_cell,
    these_cells          => $these_cells,
    post_init            => $post_init,
    pam_afs_session_args => $pam_afs_session_args,
    fn_this_cell         => $fn_this_cell,
    fn_these_cells       => $fn_these_cells,
    fn_cell_serv_db      => $fn_cell_serv_db,
    cell_serv_db_source  => $cell_serv_db_source,
    fn_cacheinfo         => $fn_cacheinfo,
    fn_post_init         => $fn_post_init,
  }

  if $config_class {
    class { "openafs::client::config::${config_class}":
      enabled              => $enabled,
      afsdb                => $afsdb,
      crypt                => $crypt,
      dynroot              => $dynroot,
      fakestat             => $fakestat,
      options              => $options,
      mount_dir            => $mount_dir,
      cache_dir            => $cache_dir,
      cacheinfo            => $cacheinfo,
      export_cell          => $export_cell,
      this_cell            => $this_cell,
      these_cells          => $these_cells,
      post_init            => $post_init,
      pam_afs_session_args => $pam_afs_session_args,
      fn_this_cell         => $fn_this_cell,
      fn_these_cells       => $fn_these_cells,
      fn_cacheinfo         => $fn_cacheinfo,
      fn_post_init         => $fn_post_init,
    }

    Class['openafs::client::install']
      -> Class["openafs::client::config::${config_class}"]
      ~> Class['openafs::client::service']
  }

  class { 'openafs::client::service':
    service    => $service,
    hasrestart => $hasrestart,
    hasstatus  => $hasstatus,
    pattern    => $pattern
  }

  anchor { 'openafs::client::begin': ; }
    -> Class['openafs::client::install']
    -> Class['openafs::client::config']
    ~> Class['openafs::client::service']
    -> anchor { 'openafs::client::end': ; }
}
