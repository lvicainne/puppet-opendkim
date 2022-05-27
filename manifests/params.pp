class opendkim::params {
  $uid = -1
  $gid = -1

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
  $senderheaders = undef
  $manage_private_keys = true
  $alldomain = false
  $selector = undef
  $publickey = undef
  $privatekey = undef
  $signaturealgorithm = undef
  $minimumkeybits = undef

  $keys = []
  $nameservers       = undef

  $removeoldsignatures = 'no'

  $service_enable    = true
  $service_ensure    = 'running'

  case $::osfamily {
    'Debian': {
      $user             = 'opendkim'
      $group            = 'opendkim'
      $service_name     = 'opendkim'
      $configfile       = '/etc/opendkim.conf'
      $sysconfigfile    = '/etc/default/opendkim'
      $configdir        = '/etc/opendkim'
    }
    'FreeBSD': {
      $user             = 'mailnull'
      $group            = 'mailnull'
      $service_name     = 'milter-opendkim'
      $configfile       = '/usr/local/etc/mail/opendkim.conf'
      $sysconfigfile    = undef
      $configdir        = '/usr/local/etc/mail/opendkim'
    }
    'Redhat': {
      $user             = 'opendkim'
      $group            = 'opendkim'
      $service_name     = 'opendkim'
      $configfile       = '/etc/opendkim.conf'
      $sysconfigfile    = '/etc/sysconfig/opendkim'
      $configdir        = '/etc/opendkim'
    }
    default: {
      fail("${::operatingsystem} is not supported by this module.")
    }
  }
}
