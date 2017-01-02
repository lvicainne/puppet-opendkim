class opendkim (
  $user                 = $opendkim::params::user,
  $group                = $opendkim::params::group,
  $uid                  = $opendkim::params::uid,
  $gid                  = $opendkim::params::gid,

  $homedir              = $opendkim::params::homedir,
  $configdir            = $opendkim::params::configdir,
  $configfile           = $opendkim::params::configfile,
  $pidfile              = $opendkim::params::pidfile,
  $sysconfigfile        = $opendkim::params::sysconfigfile,

  $package_name         = $opendkim::params::package_name,
  
  $log_why              = $opendkim::params::log_why,
  $subdomains           = $opendkim::params::subdomains,
  $socket               = $opendkim::params::socket,
  $umask                = $opendkim::params::umask,
  $trusted_hosts        = $opendkim::params::trusted_hosts,

  $keys                 = $opendkim::params::keys,

  $service_ensure       = $opendkim::params::service_ensure,
  $service_enable       = $opendkim::params::service_enable,
  $service_name         = $opendkim::params::service_name,

  ) inherits opendkim::params {

  validate_string($user)
  validate_string($group)
  validate_integer($uid)
  validate_integer($gid)

  validate_absolute_path($homedir)
  validate_absolute_path($configdir)
  validate_absolute_path($configfile)
  validate_absolute_path($pidfile)
  validate_absolute_path($sysconfigfile)

  validate_string($package_name)

  validate_string($log_why)
  validate_string($subdomains)
  validate_string($socket)
  validate_array($trusted_hosts)

  validate_array($keys)

  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_string($service_name)

  anchor { 'opendkim::begin': } ->
  class { '::opendkim::install': } ->
  class { '::opendkim::config': } ~>
  class { '::opendkim::service': } ->
  anchor { 'opendkim::end': }
}
