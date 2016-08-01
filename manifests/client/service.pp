class openafs::client::service (
  $service,
  $hasrestart,
  $hasstatus,
  $pattern
) {
  #TODO: ensure
  if $service {
    service { $service:
      ensure     => running,
      enable     => true,
      hasrestart => $hasrestart,
      hasstatus  => $hasstatus,
      pattern    => $pattern,
    }
  }
}
