# @summary This class manages the opendkim service.
#
# @param user
#   Name of the user running the service.
# @param uid
#   UserID from the user running the service.
# @param user_shell
#   Sets the login shell of user running the service.
# @param user_system
#   Switch if user should be use systemuser uid range or normal user uid range.
# @param homedir
#   Homedir of the user running the service.
# @param group
#   Name of the group running the service.
#   Also also set as primary group of the user running the service.
# @param gid
#   GroupID from the group running the service.
# @param group_system
#   Switch if group should be use systemgroup gid range or normal group gid range.
# @param configdir
#   Directory where the configurations will be located.
# @param configfile
#   Path of the main config file.
# @param pidfile
#   Path of the process id file of the service.
# @param rundir_mode
#   Run directory permission of the service.
# @param sysconfigfile
#   Path of the sysconfig file.
# @param package_name
#   Name of the package providing opendkim.
# @param service_name
#   Name of the service
# @param service_ensure
#   Defines the state of the service.
# @param service_enable
#   Switch if service should boot at startup.
#
# @param log_why
#   If logging is enabled, issues very detailed logging about the logic behind the filter’s decision to either sign a message or verify it.
# @param subdomains
#   Sign subdomains of those listed by the Domain parameter as well as the actual domains.
# @param socket
#   The socket the service should listen on.
# @param umask
#   Requests a specific permissions mask to be used for file creation. This only really applies to creation of the socket when Socket
#   specifies a UNIX domain socket, and to the PidFile.
# @param nameservers
#   List of IP addresses that are to be used when doing DNS queries to retrieve DKIM keys, VBR records, etc.
# @param mode
#   Selects operating modes. The string is a concatenation of characters that indicate which mode(s) of operation are desired.
# @param canonicalization
#   Selects the canonicalization method(s) to be used when signing messages. When verifying, the message’s DKIM-Signature: header field
#   specifies the canonicalization method. The recognized values are relaxed and simple as defined by the DKIM specification. The value may
#   include two different canonicalizations separated by a slash ("/") character, in which case the first will be applied to the header and
#   the second to the body.
# @param removeoldsignatures
#   Removes all existing signatures when operating in signing mode.
# @param maximum_signed_bytes
#   Specifies the maximum number of bytes of message body to be signed. Messages shorter than this limit will be signed in their entirety.
# @param trustanchorfile
#   Specifies a file from which trust anchor data should be read when doing DNS queries and applying the DNSSEC protocol.
# @param senderheaders
#   Specifies an ordered list of header fields that should be searched to determine the sender of a message. The first header field found
#   is the one whose value is used. This is mainly used when signing for deciding which signing request(s) to make.
# @param signaturealgorithm
#   Selects the signing algorithm to use when generating signatures.
# @param minimumkeybits
#   Establishes a minimum key size for acceptable signatures. Signatures with smaller key sizes, even if they otherwise pass DKIM
#   validation, will me marked as invalid.
# @param additional_options
#   These options will be also written into the opendkim config file
#
# @param trusted_hosts
#   Hosts that may send mail through the server as one of the signing domains without credentials and whose mail should be signed rather
#   than verified.
# @param manage_private_keys
#   Switch for the mangement of the private key files.
# @param keys
#   Structure of the keys to manage and to generate the configure from.
#
# @param alldomain
#   Switch for an alternative mangement mode that only configures one key that will be used to sign all domains.
# @param selector
#   The selector used for signing in alldomain mode.
# @param publickey
#   The publickey used for signing in alldomain mode.
# @param publickeyextended
#   The publickeyextended used for signing in alldomain mode.
# @param privatekey
#   The privatekey used for signing in alldomain mode.
# @param hash_algorithms
#   The hash_algorithms used for signing in alldomain mode.
# @param autorestart
#   Either boolean or yes/no as to whether opendkim should restart on failure
# @param autorestartrate
#   The rate limit on auto restarting
#
# @see Please see the README.md
class opendkim (
  String[1]                       $user                 = 'opendkim',
  Optional[Integer[0]]            $uid                  = undef,
  Stdlib::Absolutepath            $user_shell           = '/usr/sbin/nologin',
  Boolean                         $user_system          = true,
  Stdlib::Absolutepath            $homedir              = '/run/opendkim',
  String[1]                       $group                = 'opendkim',
  Optional[Integer[0]]            $gid                  = undef,
  Boolean                         $group_system         = true,

  Stdlib::Absolutepath            $configdir            = '/etc/opendkim',
  Stdlib::Absolutepath            $configfile           = '/etc/opendkim.conf',
  Stdlib::Absolutepath            $pidfile              = '/run/opendkim/opendkim.pid',
  Pattern[/\A[0-7]{3,4}\z/]       $rundir_mode          = '0755',
  Optional[Stdlib::Absolutepath]  $sysconfigfile        = undef,
  String[1]                       $package_name         = 'opendkim',
  String[1]                       $service_name         = 'opendkim',
  Stdlib::Ensure::Service         $service_ensure       = 'running',
  Boolean                         $service_enable       = true,

  Variant[Boolean,Enum['yes','no']]                $log_why              = 'no',
  Variant[Boolean,Enum['yes','no']]                $subdomains           = 'yes',
  String                          $socket               = 'inet:8891@[127.0.0.1]',
  Pattern[/\A[0-7]{3,4}\z/]       $umask                = '0022',
  Array[Stdlib::IP::Address]      $nameservers          = [],
  Pattern[/\A[sv]{1,2}\z/]        $mode                 = 'sv',
  Pattern[/\A((relaxed|simple)\/)?(relaxed|simple)\z/] $canonicalization = 'relaxed/simple',
  Variant[Boolean,Enum['yes','no']]                $removeoldsignatures  = 'no',
  Optional[Integer[1]]            $maximum_signed_bytes = undef,
  Optional[Stdlib::Absolutepath]  $trustanchorfile      = undef,
  Optional[Array[String,1]]       $senderheaders        = undef,

  Optional[String[1]]             $signaturealgorithm   = undef,
  Optional[Integer[1]]            $minimumkeybits       = undef,
  Hash[String,Variant[Array[String],String,Integer,Boolean]]             $additional_options   = {},

  Array[String,1]                 $trusted_hosts        = ['::1', '127.0.0.1', 'localhost'],
  Boolean                         $manage_private_keys  = true,
  Array[Opendkim::Key]            $keys                 = [],

  Boolean                         $alldomain            = false,
  Optional[String[1]]             $selector             = undef,
  Optional[String[1]]             $publickey            = undef,
  Optional[String[1]]             $publickeyextended    = undef,
  Optional[String[1]]             $privatekey           = undef,
  Optional[String[1]]             $hash_algorithms      = undef,
  Optional[Variant[Boolean,Enum['yes','no']]] $autorestart            = undef,
  Optional[Pattern[/\A[0-9]+\/[0-9]+[sSmMhHdD]\z/]] $autorestartrate  = undef,
) {
  contain opendkim::install
  contain opendkim::user
  contain opendkim::config
  contain opendkim::service

  Class['opendkim::install']
  -> Class['opendkim::user']
  -> Class['opendkim::config']
  ~> Class['opendkim::service']
}
