# @summary Validate an opendkim key struct
type Opendkim::Key = Struct[{
    domain            => String[1],
    selector          => String[1],
    key_algorithm     => Optional[String[1]],
    hash_algorithms   => Optional[String[1]],
    publickey         => String[1],
    publickeyextended => Optional[String[1]],
    privatekey        => Variant[String[1],Deferred],
    signingdomains    => Array[String[1]],
}]
