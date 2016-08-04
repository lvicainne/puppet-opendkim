class opendkim::install inherits opendkim {

  package { 'opendkim':
    ensure => installed,
    name   => $::opendkim::package_name,
  }

}
