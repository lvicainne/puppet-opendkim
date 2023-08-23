# @summary Managing the opendkim service
#
# @api private
class opendkim::service {
  assert_private()

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
