# @summary Configure opendkim
#
# @api private
class opendkim::config {
  assert_private()

  if $opendkim::sysconfigfile {
    file { $opendkim::sysconfigfile:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => epp("${module_name}/sysconfig/opendkim.epp", {
          'socket'     => $opendkim::socket,
          'configfile' => $opendkim::configfile,
          'configdir'  => $opendkim::configdir,
          'pidfile'    => $opendkim::pidfile,
      }),
    }
  }

  if fact('os.family') == 'FreeBSD' {
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

  $_piddir = dirname($opendkim::pidfile)
  if fact('os.family') == 'RedHat' {
    file_line { "${opendkim::service_name}.service RuntimeDirectory":
      path  => "/usr/lib/systemd/system/${opendkim::service_name}.service",
      line  => "RuntimeDirectory=${basename($_piddir)}",
      match => '^RuntimeDirectory=',
      after => '^Restart=',
    }
    -> file_line { "${opendkim::service_name}.service RuntimeDirectoryMode":
      path  => "/usr/lib/systemd/system/${opendkim::service_name}.service",
      line  => "RuntimeDirectoryMode=${opendkim::rundir_mode}",
      match => '^RuntimeDirectoryMode=',
      after => '^RuntimeDirectory=',
    }

    file { '/etc/tmpfiles.d/opendkim.conf':
      ensure => absent,
    }
  } else {
    file { $_piddir:
      ensure => directory,
      owner  => $opendkim::user,
      group  => $opendkim::group,
      mode   => $opendkim::rundir_mode,
    }
  }

  unless defined(File[$opendkim::homedir]) or $opendkim::homedir == $_piddir {
    file { $opendkim::homedir:
      ensure => directory,
      owner  => $opendkim::user,
      group  => $opendkim::group,
      mode   => '0755',
    }
  }

  file { $opendkim::configdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
  }

  file { "${opendkim::configdir}/keys":
    ensure => directory,
    owner  => $opendkim::user,
    group  => $opendkim::group,
    mode   => '0640',
  }

  $_other_configdirs = ['/etc/opendkim', '/etc/dkim'] - $opendkim::configdir
  $_other_configdirs.each |Stdlib::Absolutepath $_file| {
    file { $_file:
      ensure => absent,
      force  => true,
    }
  }

  file { $opendkim::configfile:
    ensure  => 'file',
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
    content => epp("${module_name}/etc/opendkim.conf.epp", {
        'pidfile'              => $opendkim::pidfile,
        'mode'                 => $opendkim::mode,
        'log_why'              => $opendkim::log_why,
        'user'                 => $opendkim::user,
        'group'                => $opendkim::group,
        'socket'               => $opendkim::socket,
        'umask'                => $opendkim::umask,
        'canonicalization'     => $opendkim::canonicalization,
        'alldomain'            => $opendkim::alldomain,
        'selector'             => $opendkim::selector,
        'configdir'            => $opendkim::configdir,
        'subdomains'           => $opendkim::subdomains,
        'nameservers'          => $opendkim::nameservers,
        'removeoldsignatures'  => $opendkim::removeoldsignatures,
        'maximum_signed_bytes' => $opendkim::maximum_signed_bytes,
        'trustanchorfile'      => $opendkim::trustanchorfile,
        'senderheaders'        => $opendkim::senderheaders,
        'signaturealgorithm'   => $opendkim::signaturealgorithm,
        'minimumkeybits'       => $opendkim::minimumkeybits,
        'additional_options'   => $opendkim::additional_options,
    }),
  }

  file { "${opendkim::configdir}/TrustedHosts":
    ensure  => file,
    owner   => $opendkim::user,
    group   => $opendkim::group,
    mode    => '0640',
    content => epp("${module_name}/etc/TrustedHosts.epp", {
        'trusted_hosts' => $opendkim::trusted_hosts,
    }),
  }

  if $opendkim::alldomain {
    if $opendkim::manage_private_keys == true {
      file { "${opendkim::configdir}/keys/${opendkim::selector}":
        ensure  => file,
        content => $opendkim::privatekey,
        owner   => 'root',
        group   => $opendkim::group,
        mode    => '0640',
      }
    }

    file { "${opendkim::configdir}/keys/${opendkim::selector}.txt":
      ensure  => 'file',
      content => epp("${module_name}/public-rsa-key.epp", {
          'selector'          => $opendkim::selector,
          'domain'            => 'all',
          'publickey'         => $opendkim::publickey,
          'publickeyextended' => pick_default($opendkim::publickeyextended, undef),
          'hash_algorithms'   => pick_default($opendkim::hash_algorithms, undef),
      }),
      owner   => 'root',
      group   => $opendkim::group,
      mode    => '0640',
    }
  } else {
    file { "${opendkim::configdir}/SigningTable":
      ensure  => 'file',
      owner   => $opendkim::user,
      group   => $opendkim::group,
      mode    => '0640',
      content => epp("${module_name}/etc/SigningTable.epp", {
          'keys' => $opendkim::keys,
      }),
    }

    file { "${opendkim::configdir}/KeyTable":
      ensure  => 'file',
      owner   => $opendkim::user,
      group   => $opendkim::group,
      mode    => '0640',
      content => epp("${module_name}/etc/KeyTable.epp", {
          'keys'      => $opendkim::keys,
          'configdir' => $opendkim::configdir,
      }),
    }

    $opendkim::keys.each |Hash $key| {
      ensure_resource('file', "${opendkim::configdir}/keys/${key['domain']}", {
          ensure  => directory,
          recurse => true,
          owner   => $opendkim::user,
          group   => $opendkim::group,
          mode    => '0700',
      })

      if $opendkim::manage_private_keys == true {
        file { "${opendkim::configdir}/keys/${key['domain']}/${key['selector']}":
          ensure  => 'file',
          content => $key['privatekey'],
          owner   => $opendkim::user,
          group   => $opendkim::group,
          mode    => '0600',
        }
      }

      file { "${opendkim::configdir}/keys/${key['domain']}/${key['selector']}.txt":
        ensure  => file,
        content => epp("${module_name}/public-rsa-key.epp", {
            'selector'          => $key['selector'],
            'domain'            => $key['domain'],
            'publickey'         => $key['publickey'],
            'publickeyextended' => $key.get('publickeyextended'),
            'hash_algorithms'   => $key.get('hash_algorithms'),
        }),
        owner   => $opendkim::user,
        group   => $opendkim::group,
        mode    => '0600',
      }
    }
  }
}
