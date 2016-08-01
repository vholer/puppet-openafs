class openafs::client::install (
  $ensure,
  $packages,
  $packages_kmod,
  $apt_release,
  $own_repo_class,
) {
  if $own_repo_class != '' {
    require($own_repo_class)
  }

  if ($::osfamily == 'Debian') and $apt_release {
    $_install_options = { '-t' => $apt_release }
  }

  if size($packages_kmod)>0 {
    package { $packages_kmod:
      ensure          => $ensure,
      install_options => $_install_options,
      before          => Package[$packages],
    }
  }

  if size($packages)>0 {
    # TODO: Debian preseeding
    package { $packages:
      ensure          => $ensure,
      install_options => $_install_options,
    }
  } else {
    warning('No OpenAFS client package(s) for installation')
  }
}
