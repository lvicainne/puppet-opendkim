# OpenDKIM

[![Puppet Forge](http://img.shields.io/puppetforge/v/lvicainne/opendkim.svg)](https://forge.puppetlabs.com/lvicainne/opendkim)
[![Build Status](https://travis-ci.org/lvicainne/puppet-opendkim.svg?branch=master)](https://travis-ci.org/lvicainne/puppet-opendkim)

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with OpenDKIM](#setup)
    * [What opendkim module affects](#what-opendkim-module-affects)
    * [Beginning with opendkim](#beginning-with-opendkim)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

A Puppet module to install and manage OpenDKIM

## Setup

### What OpenDKIM affects {#what-opendkim-module-affects}

* install OpenDKIM package
* modify the configuration file /etc/opendkim.conf
* add and modify files in /etc/opendkim
* purge /etc/opendkim and /etc/dkim from all unuseful files

Warning : this package will replace all your RSA keys ! Before using it, be sure to add all your keys in Hiera !

### Beginning with OpenDKIM

A basic example is as follows:

```puppet
class { '::opendkim':
  socket        => 'inet:8891@127.0.0.1',
  trusted_hosts => ['::1','127.0.0.1','localhost'],
  keys          => [
      { 
          domain         => 'mydomain.com',
          selector       => 'default',
          publickey      => 'p=yourPublicKey',
          privatekey     => 'Your Private Key',
          signingdomains => ['*@mydomain.com', '*@subdomain.mydomain.com'],
      }
  ]
}
```

## Usage

You can also use natively Hiera :

```puppet
include ::opendkim
```

```yaml
opendkim::socket: 'inet:8891@127.0.0.1'
opendkim::trusted_hosts:
    - '::1'
    - '127.0.0.1'
    - 'localhost'
opendkim::keys:
    - domain: mydomain.com
      selector: default
      hash_algorithms: "sha1256"
      publickey: "p=yourPublicKey"
      publickeyextended: "secondLineofPublicKey"
      privatekey: | 
        -----BEGIN RSA PRIVATE KEY-----
        Your Private Key
        -----END RSA PRIVATE KEY-----
      signingdomains: 
          - '*@mydomain.com'
          - '*@subdomain.mydomain.com'
```

If you want to use OpenDKIM though a UNIX socket with postfix for example, 
you should configure the socket like this :

```yaml
opendkim::socket: 'local:/var/run/opendkim/opendkim.sock'
opendkim::umask: '0111'
```

## Limitations

This module has only been tested on my Debian and Centos servers. I can not guarantee for any other Operating System

## Development

You are pleased to fork this module and adapt it for you needs. I am open to any Pull Request :-)
