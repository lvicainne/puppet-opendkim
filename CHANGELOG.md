# Changelog

## v0.4.2 - Compatible with Puppet from 6.24 up to, but not including, 8.0

### What's Changed

* Lookup osfamily for RedHat clones by @msalway in <https://github.com/lvicainne/puppet-opendkim/pull/43>
* Missing Optional for autorestart by @msalway in <https://github.com/lvicainne/puppet-opendkim/pull/44>
* chore: update module version and metadata by @parveenk27 in <https://github.com/lvicainne/puppet-opendkim/pull/54>
* Chunking publickey in 255 char blocks for dns txt by @cruelsmith in <https://github.com/lvicainne/puppet-opendkim/pull/51>
* Add SignHeaders From by @seriv in <https://github.com/lvicainne/puppet-opendkim/pull/48>
* feat(pdk): enable pdk to improve test and reliability of the module by @lvicainne in <https://github.com/lvicainne/puppet-opendkim/pull/55>

### New Contributors

* @parveenk27 made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/54>
* @seriv made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/48>

**Full Changelog**: <https://github.com/lvicainne/puppet-opendkim/compare/v0.4.0...v0.4.2>

## v0.4.0

### What's Changed

* Add Missing Socket for Ubuntu 16.04 by @HielkeJ in <https://github.com/lvicainne/puppet-opendkim/pull/3>
* Replace deprecated stdlib functions with puppet data types by @jkroepke in <https://github.com/lvicainne/puppet-opendkim/pull/5>
* Removed full path comments on configfile by @jkroepke in <https://github.com/lvicainne/puppet-opendkim/pull/6>
* Adding nameserver config paramter by @jkroepke in <https://github.com/lvicainne/puppet-opendkim/pull/7>
* if you default it to undef in params, you need to make it Optional to acce… by @qs5779 in <https://github.com/lvicainne/puppet-opendkim/pull/8>
* add force to directory absent resources by @qs5779 in <https://github.com/lvicainne/puppet-opendkim/pull/9>
* Add parameters: mode, canonicalization, removeoldsignatures by @sa5bke in <https://github.com/lvicainne/puppet-opendkim/pull/12>
* Add support for MaximumSignedBytes by @tetsuo13 in <https://github.com/lvicainne/puppet-opendkim/pull/13>
* Make sure to create users before package installation by @Arakmar in <https://github.com/lvicainne/puppet-opendkim/pull/14>
* Allow handling of private keys outsite puppet by @jeebiq in <https://github.com/lvicainne/puppet-opendkim/pull/18>
* Test bumping version by @cFire in <https://github.com/lvicainne/puppet-opendkim/pull/17>
* add ability to validate dnssec by @tobiWu in <https://github.com/lvicainne/puppet-opendkim/pull/19>
* Fix duplicate resource if multiple keys are added for a domain by @nikdoof in <https://github.com/lvicainne/puppet-opendkim/pull/16>
* make trustanchorfile optional by @antondollmaier in <https://github.com/lvicainne/puppet-opendkim/pull/20>
* Add support for FreeBSD by @smortex in <https://github.com/lvicainne/puppet-opendkim/pull/21>
* Add management of /etc/tmpfiles.d/opendkim.conf for RedHat by @razorbladex401 in <https://github.com/lvicainne/puppet-opendkim/pull/22>
* Allow to apply a DKIM cert on all domains by @kapouik in <https://github.com/lvicainne/puppet-opendkim/pull/24>
* Allow stdlib v8 by @sazzle2611 in <https://github.com/lvicainne/puppet-opendkim/pull/25>
* Allow private keys to be Deferred for use with node_encrypt by @msalway in <https://github.com/lvicainne/puppet-opendkim/pull/28>
* Add SenderHeaders option to opendkim.conf by @tallenaz in <https://github.com/lvicainne/puppet-opendkim/pull/29>
* Fix legacy fact usage by @smortex in <https://github.com/lvicainne/puppet-opendkim/pull/30>
* Adds Parameters to support 2048 bit keys and Specifying hash_algorithms by @razorbladex401 in <https://github.com/lvicainne/puppet-opendkim/pull/31>
* Rework module to hiera and epp templates by @cruelsmith in <https://github.com/lvicainne/puppet-opendkim/pull/35>
* chore(puppet): update module version and metadata by @lvicainne in <https://github.com/lvicainne/puppet-opendkim/pull/36>
* Fix default value for sysconfigfile by @smortex in <https://github.com/lvicainne/puppet-opendkim/pull/37>
* Edit file ownership and permissions by @tallenaz in <https://github.com/lvicainne/puppet-opendkim/pull/41>
* Add autorestart config by @coreone in <https://github.com/lvicainne/puppet-opendkim/pull/42>

## New Contributors

* @HielkeJ made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/3>
* @jkroepke made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/5>
* @qs5779 made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/8>
* @sa5bke made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/12>
* @tetsuo13 made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/13>
* @Arakmar made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/14>
* @jeebiq made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/18>
* @cFire made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/17>
* @tobiWu made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/19>
* @nikdoof made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/16>
* @antondollmaier made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/20>
* @smortex made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/21>
* @razorbladex401 made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/22>
* @kapouik made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/24>
* @sazzle2611 made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/25>
* @tallenaz made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/29>
* @coreone made their first contribution in <https://github.com/lvicainne/puppet-opendkim/pull/42>

**Full Changelog**: <https://github.com/lvicainne/puppet-opendkim/commits/v0.4.0>
