class opendkim::params {
  $user = 'opendkim'
  $group = 'opendkim'
  $uid = 5010
  $gid = 5010

  $configfile  = '/etc/opendkim.conf'
  $pidfile = '/var/run/opendkim/opendkim.pid'
  $homedir = '/var/run/opendkim'

  $package_name = 'opendkim'

  $log_why = 'no'
  $subdomains = 'yes'
  $socket = 'inet:8891@127.0.0.1'
  $umask = '0022'
  $trusted_hosts = ['::1', '127.0.0.1', 'localhost']

  $keys = []

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
      $configdir        = '/etc/dkim'
    }
    default: {
      fail("${::operatingsystem} is not supported by this module.")
    }
  }
}
