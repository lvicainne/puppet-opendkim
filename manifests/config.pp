class opendkim::config inherits opendkim {

  group { 'opendkim':
    ensure => 'present',
    name   => $opendkim::group,
    gid    => $opendkim::gid,
  }

  $shelluser = $::osfamily ? {
    'RedHat' => '/sbin/nologin',
    default  => '/usr/sbin/nologin',
  }

  user { 'opendkim':
    ensure   => 'present',
    name     => $opendkim::user,
    gid      => $opendkim::gid,
    home     => $opendkim::homedir,
    password => '!!',
    shell    => $shelluser,
    uid      => $opendkim::uid,
  }

  file { $opendkim::sysconfigfile:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('opendkim/sysconfig/opendkim.erb'),
  }

  $piddir = dirname($opendkim::pidfile )
  file { $piddir:
    ensure => 'directory',
    owner  => $opendkim::user,
    group  => $opendkim::group,
    mode   => '0755',
  }

  file { "${opendkim::configdir}/keys":
    ensure => 'directory',
    owner  => $opendkim::user,
    group  => $opendkim::group,
    mode   => '0640',
  }

  if !defined(File[$opendkim::homedir]) {
    file { $opendkim::homedir:
      ensure => 'directory',
      owner  => $opendkim::user,
      group  => $opendkim::group,
      mode   => '0755',
    }
  }

  file { $opendkim::configdir:
    ensure  => 'directory',
    recurse => true,
    purge   => true,
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
  }

  if($opendkim::configdir != '/etc/opendkim') {
    file { '/etc/opendkim':
      ensure => 'absent',
    }
  }

  if($opendkim::configdir != '/etc/dkim') {
    file { '/etc/dkim':
      ensure => 'absent',
    }
  }


  file { 'opendkim-conf':
    ensure  => 'file',
    path    => $opendkim::configfile,
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
    content => template('opendkim/etc/opendkim.conf.erb'),
  }

  file { 'opendkim-TrustedHosts':
    ensure  => 'file',
    path    => "${opendkim::configdir}/TrustedHosts",
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
    content => template('opendkim/etc/TrustedHosts.erb'),
  }

  file { 'opendkim-SigningTable':
    ensure  => 'file',
    path    => "${opendkim::configdir}/SigningTable",
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
    content => template('opendkim/etc/SigningTable.erb'),
  }

  file { 'opendkim-KeyTable':
    ensure  => 'file',
    path    => "${opendkim::configdir}/KeyTable",
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
    content => template('opendkim/etc/KeyTable.erb'),
  }

  $opendkim::keys.each |Hash $key| {
    file { "${opendkim::configdir}/keys/${key['domain']}":
      ensure  => 'directory',
      recurse => true,
      owner   => $opendkim::user,
      group   => $opendkim::group,
      mode    => '0600',
    }


    file { "${opendkim::configdir}/keys/${key['domain']}/${key['selector']}":
      ensure  => 'file',
      content => $key['privatekey'],
      owner   => $opendkim::user,
      group   => $opendkim::group,
      mode    => '0600',
    }

    $selector = $key['selector']
    $domain = $key['domain']
    $publickey = $key['publickey']

    file { "${opendkim::configdir}/keys/${key['domain']}/${key['selector']}.txt":
      ensure  => 'file',
      content => template('opendkim/public-rsa-key.erb'),
      owner   => $opendkim::user,
      group   => $opendkim::group,
      mode    => '0600',
    }

  }

}
