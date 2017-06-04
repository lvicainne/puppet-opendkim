# == Class: opendkim
#
#This class manages the opendkim service.
#
#Please see the README.md
class opendkim(
  String                    $user               = $opendkim::params::user,
  String                    $group              = $opendkim::params::group,
  Integer                   $uid                = $opendkim::params::uid,
  Integer                   $gid                = $opendkim::params::gid,

  Stdlib::Absolutepath      $homedir            = $opendkim::params::homedir,
  Stdlib::Absolutepath      $configdir          = $opendkim::params::configdir,
  Stdlib::Absolutepath      $configfile         = $opendkim::params::configfile,
  Stdlib::Absolutepath      $pidfile            = $opendkim::params::pidfile,
  Stdlib::Absolutepath      $sysconfigfile      = $opendkim::params::sysconfigfile,
  String                    $package_name       = $opendkim::params::package_name,
  String                    $log_why            = $opendkim::params::log_why,
  String                    $subdomains         = $opendkim::params::subdomains,
  String                    $socket             = $opendkim::params::socket,
  String                    $umask              = $opendkim::params::umask,
  Array[String]             $trusted_hosts      = $opendkim::params::trusted_hosts,

  Array[Struct[{
    domain         => String,
    selector       => String,
    publickey      => String,
    privatekey     => String,
    signingdomains => Array[String],
  }]]                       $keys               = $opendkim::params::keys,

  Enum['running','stopped'] $service_ensure     = $opendkim::params::service_ensure,
  Boolean                   $service_enable     = $opendkim::params::service_enable,
  String                    $service_name       = $opendkim::params::service_name,
) inherits opendkim::params {

  anchor { 'opendkim::begin': }
  -> class { '::opendkim::install': }
  -> class { '::opendkim::config': }
  ~> class { '::opendkim::service': }
  -> anchor { 'opendkim::end': }

}