# Class opendkim::config
class opendkim::config inherits opendkim {
  if $opendkim::sysconfigfile {
    file { $opendkim::sysconfigfile:
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template('opendkim/sysconfig/opendkim.erb'),
    }
  }

  if $::osfamily == 'FreeBSD' {
    file_line {
      default:
        path => '/etc/rc.conf',
        ;
      'milteropendkim_uid':
        line  => "milteropendkim_uid=\"${opendkim::user}\"",
        match => '^milteropendkim_uid=',
        ;
      'milteropendkim_gid':
        line  => "milteropendkim_gid=\"${opendkim::group}\"",
        match => '^milteropendkim_gid=',
        ;
    }
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
    owner  => 'root',
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
    owner   => 'root',
    group   => $opendkim::group,
    mode    => '0640',
  }

  if($opendkim::configdir != '/etc/opendkim') {
    file { '/etc/opendkim':
      ensure => 'absent',
      force  => true,
    }
  }

  if($opendkim::configdir != '/etc/dkim') {
    file { '/etc/dkim':
      ensure => 'absent',
      force  => true,
    }
  }


  file { 'opendkim-conf':
    ensure  => 'file',
    path    => $opendkim::configfile,
    owner   => 'root',
    group   => $opendkim::group,
    mode    => '0640',
    content => template('opendkim/etc/opendkim.conf.erb'),
  }

  if $::osfamily == 'RedHat' {
    file {'/etc/tmpfiles.d/opendkim.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/opendkim/tmpfiles.d/opendkim.conf',
    }
  }

  file { 'opendkim-TrustedHosts':
    ensure  => 'file',
    path    => "${opendkim::configdir}/TrustedHosts",
    owner   => 'root',
    group   => $opendkim::group,
    mode    => '0640',
    content => template('opendkim/etc/TrustedHosts.erb'),
  }

  if $opendkim::alldomain {

    if($opendkim::manage_private_keys == true) {
      file { "${opendkim::configdir}/keys/${opendkim::selector}":
        ensure  => 'file',
        content => $opendkim::privatekey,
        owner   => 'root',
        group   => $opendkim::group,
        mode    => '0640',
      }
    }

    $selector = $opendkim::selector
    $domain = 'all'
    $publickey = $opendkim::publickey

    file { "${opendkim::configdir}/keys/${opendkim::selector}.txt":
      ensure  => 'file',
      content => template('opendkim/public-rsa-key.erb'),
      owner   => 'root',
      group   => $opendkim::group,
      mode    => '0640',
    }

  } else {

    file { 'opendkim-SigningTable':
      ensure  => 'file',
      path    => "${opendkim::configdir}/SigningTable",
      owner   => 'root',
      group   => $opendkim::group,
      mode    => '0640',
      content => template('opendkim/etc/SigningTable.erb'),
    }

    file { 'opendkim-KeyTable':
      ensure  => 'file',
      path    => "${opendkim::configdir}/KeyTable",
      owner   => 'root',
      group   => $opendkim::group,
      mode    => '0640',
      content => template('opendkim/etc/KeyTable.erb'),
    }

    $opendkim::keys.each |Hash $key| {
      ensure_resource('file', "${opendkim::configdir}/keys/${key['domain']}", {
        ensure  => 'directory',
        recurse => true,
        owner   => 'root',
        group   => $opendkim::group,
        mode    => '0710',
      })

      if($opendkim::manage_private_keys == true) {
        file { "${opendkim::configdir}/keys/${key['domain']}/${key['selector']}":
          ensure  => 'file',
          content => $key['privatekey'],
          owner   => 'root',
          group   => $opendkim::group,
          mode    => '0640',
        }
      }

      $selector = $key['selector']
      $domain = $key['domain']
      $publickey = $key['publickey']

      file { "${opendkim::configdir}/keys/${key['domain']}/${key['selector']}.txt":
        ensure  => 'file',
        content => template('opendkim/public-rsa-key.erb'),
        owner   => 'root',
        group   => $opendkim::group,
        mode    => '0640',
      }

    }

  }

}
