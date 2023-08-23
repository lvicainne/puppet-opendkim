# @summary Managing the opendkim installation
#
# @api private
class opendkim::install {
  assert_private()

  package { 'opendkim':
    ensure => installed,
    name   => $opendkim::package_name,
  }
}
