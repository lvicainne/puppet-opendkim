# == Class: opendkim
#
#This class manages the opendkim service.
#
#Please see the README.md
class opendkim(
  String                    $user                 = $opendkim::params::user,
  String                    $group                = $opendkim::params::group,
  Integer[-1]               $uid                  = $opendkim::params::uid,
  Integer[-1]               $gid                  = $opendkim::params::gid,

  Stdlib::Absolutepath      $homedir              = $opendkim::params::homedir,
  Stdlib::Absolutepath      $configdir            = $opendkim::params::configdir,
  Stdlib::Absolutepath      $configfile           = $opendkim::params::configfile,
  Stdlib::Absolutepath      $pidfile              = $opendkim::params::pidfile,
  Optional[Stdlib::Absolutepath] $sysconfigfile   = $opendkim::params::sysconfigfile,
  String                    $package_name         = $opendkim::params::package_name,
  String                    $log_why              = $opendkim::params::log_why,
  String                    $subdomains           = $opendkim::params::subdomains,
  String                    $socket               = $opendkim::params::socket,
  String                    $umask                = $opendkim::params::umask,
  Optional[String]          $nameservers          = $opendkim::params::nameservers,
  Array[String]             $trusted_hosts        = $opendkim::params::trusted_hosts,
  String                    $mode                 = $opendkim::params::mode,
  String                    $canonicalization     = $opendkim::params::canonicalization,
  String                    $removeoldsignatures  = $opendkim::params::removeoldsignatures,
  Optional[Integer]         $maximum_signed_bytes = $opendkim::params::maximum_signed_bytes,
  Optional[String]          $trustanchorfile      = $opendkim::params::trustanchorfile,
  Optional[Array]           $senderheaders        = $opendkim::params::senderheaders,
  Boolean                   $manage_private_keys  = $opendkim::params::manage_private_keys,
  Boolean                   $alldomain            = $opendkim::params::alldomain,
  Optional[String]          $selector             = $opendkim::params::selector,
  Optional[String]          $publickey            = $opendkim::params::publickey,
  Optional[String]          $publickeyextended    = $opendkim::params::publickeyextended,
  Optional[String]          $privatekey           = $opendkim::params::privatekey,
  Optional[String]          $hash_algorithms      = $opendkim::params::hash_algorithms,
  Optional[String]          $signaturealgorithm   = $opendkim::params::signaturealgorithm,
  Optional[Integer]         $minimumkeybits       = $opendkim::params::minimumkeybits,

  Array[Struct[{
    domain            => String,
    selector          => String,
    hash_algorithms   => String,
    publickey         => String,
    publickeyextended => String,
    privatekey        => Variant[String,Deferred],
    signingdomains    => Array[String],
  }]]                       $keys                 = $opendkim::params::keys,

  Enum['running','stopped'] $service_ensure       = $opendkim::params::service_ensure,
  Boolean                   $service_enable       = $opendkim::params::service_enable,
  String                    $service_name         = $opendkim::params::service_name,
) inherits opendkim::params {

  anchor { 'opendkim::begin': }
  -> class { '::opendkim::user': }
  -> class { '::opendkim::install': }
  -> class { '::opendkim::config': }
  ~> class { '::opendkim::service': }
  -> anchor { 'opendkim::end': }

}
