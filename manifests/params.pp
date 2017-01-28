class openafs::params {
  $ensure = latest
  $apt_release = ''
  $apt_version = false

  $client_enabled = true
  $client_afsdb = true
  $client_crypt = true
  $client_dynroot = true
  $client_fakestat = true
  $client_options = ''
  $client_mount_dir = '/afs'
  $client_cacheinfo = "<%= @mount_dir %>:<%= @cache_dir %>:400000\n" #erb
  $client_export_cell = true
  $client_this_cell = 'openafs.org'
  $client_these_cells = []
  $client_cell_serv_db_source = ''
  $client_post_init = ''
  $client_pam_afs_session_args = []
  $client_notify_service = true

  case $::operatingsystem {
    debian: {
      case $::operatingsystemmajrelease {
        7, 8: {
          $cache_dir = '/var/cache/openafs'
          $fn_this_cell = '/etc/openafs/ThisCell'
          $fn_these_cells = '/etc/openafs/TheseCells'
          $fn_cell_serv_db = '/etc/openafs/CellServDB'
          $fn_cacheinfo = '/etc/openafs/cacheinfo'
          $fn_post_init = '/etc/openafs/post_init.sh'

          $client_require_class = '::dkms'
          $client_config_class = 'debian'
          $client_packages_kmod = ['openafs-modules-dkms']
          $client_packages = ['openafs-client', 'openafs-krb5', 'libpam-afs-session']
          $client_service = 'openafs-client'
          $client_service_hasrestart = true
          $client_service_hasstatus = false
          $client_service_pattern = 'afsd'
        }

        default: {
          fail("Unsupported OS release: \
${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }

    sles,sled: {
      case $::operatingsystemmajrelease {
        11: {
          $cache_dir = '/var/cache/openafs'
          $fn_this_cell = '/etc/openafs/ThisCell'
          $fn_these_cells = '/etc/openafs/TheseCells'
          $fn_cell_serv_db = '/etc/openafs/CellServDB'
          $fn_cacheinfo = '/etc/openafs/cacheinfo'
          $fn_post_init = ''

          $client_require_class = ''
          $client_config_class = 'suse'
          $client_packages_kmod = ['openafs-kmp-default']
          $client_packages = ['openafs-client']
          $client_service = 'openafs-client'
          $client_service_hasrestart = true
          $client_service_hasstatus = true
          $client_service_pattern = 'afsd'
        }

        default: {
          fail("Unsupported OS release: \
${::operatingsystem} ${::operatingsystemmajrelease}")
        }
      }
    }

    default: {
      fail("Unsupported OS: ${::operatingsystem}")
    }
  }
}
