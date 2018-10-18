class opendkim::user inherits opendkim {
  if $opendkim::gid > -1 {
    group { 'opendkim':
      ensure => 'present',
      name   => $opendkim::group,
      gid    => $opendkim::gid,
    }
  } else {
    group { 'opendkim':
      ensure => 'present',
      name   => $opendkim::group,
    }
  }

  $shelluser = $::osfamily ? {
    'RedHat' => '/sbin/nologin',
    default  => '/usr/sbin/nologin',
  }

  if $opendkim::uid > -1 and $opendkim::gid > -1 {
    user { 'opendkim':
      ensure   => 'present',
      name     => $opendkim::user,
      gid      => $opendkim::gid,
      home     => $opendkim::homedir,
      password => '!!',
      shell    => $shelluser,
      uid      => $opendkim::uid,
    }
  } elsif $opendkim::uid > -1 {
    user { 'opendkim':
      ensure   => 'present',
      name     => $opendkim::user,
      home     => $opendkim::homedir,
      password => '!!',
      shell    => $shelluser,
      uid      => $opendkim::uid,
    }

  } elsif $opendkim::gid > -1 {
    user { 'opendkim':
      ensure   => 'present',
      name     => $opendkim::user,
      gid      => $opendkim::gid,
      home     => $opendkim::homedir,
      password => '!!',
      shell    => $shelluser,
    }

  } else {
    user { 'opendkim':
      ensure   => 'present',
      name     => $opendkim::user,
      home     => $opendkim::homedir,
      password => '!!',
      shell    => $shelluser,
    }
  }
}
