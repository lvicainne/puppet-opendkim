class opendkim::params {
  $user = 'opendkim'
  $group = 'opendkim'
  $uid = -1
  $gid = -1

  $configfile  = '/etc/opendkim.conf'
  $pidfile = '/var/run/opendkim/opendkim.pid'
  $homedir = '/var/run/opendkim'
  $mode = 'sv'

  $package_name = 'opendkim'

  $log_why = 'no'
  $canonicalization = 'relaxed/simple'
  $subdomains = 'yes'
  $socket = 'inet:8891@127.0.0.1'
  $umask = '0022'
  $trusted_hosts = ['::1', '127.0.0.1', 'localhost']
  $maximum_signed_bytes = undef
  $trustanchorfile  = undef

  $keys = []
  $nameservers       = undef

  $removeoldsignatures = 'no'

  $service_enable    = true
  $service_ensure    = 'running'
  $service_name      = 'opendkim'

  case $::osfamily {
    'Debian': {
      $sysconfigfile    = '/etc/default/opendkim'
      $configdir        = '/etc/opendkim'
    }
    'Redhat': {
      $sysconfigfile    = '/etc/sysconfig/opendkim'
      $configdir        = '/etc/opendkim' 
    }
    default: {
      fail("${::operatingsystem} is not supported by this module.")
    }
  }
}
