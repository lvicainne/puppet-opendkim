class opendkim::service inherits opendkim {
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
