class opendkim::service inherits opendkim {

  if ! ($opendkim::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  service { 'opendkim':
    ensure     => $opendkim::service_ensure,
    enable     => $opendkim::service_enable,
    name       => $opendkim::service_name,
    hasstatus  => true,
    hasrestart => true,
    pattern    => 'opendkim',
    require    => Package['opendkim'],
  }
}
