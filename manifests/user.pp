# @summary Managing the opendkim user
#
# @api private
class opendkim::user {
  assert_private()

  group { 'opendkim':
    ensure => present,
    name   => $opendkim::group,
    gid    => $opendkim::gid,
    system => $opendkim::group_system,
  }

  user { 'opendkim':
    ensure   => present,
    gid      => $opendkim::gid,
    home     => $opendkim::homedir,
    name     => $opendkim::user,
    password => '!!',
    shell    => $opendkim::user_shell,
    system   => $opendkim::user_system,
    uid      => $opendkim::uid,
  }
}
