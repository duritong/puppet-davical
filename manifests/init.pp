# modules/davical/manifests/init.pp - manage davical stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

import 'defines.pp'

class davical {
    case $operatingsystem {
        default: { include davical::base }
    }
}

class davical::base {
  package{ [ 'davical', 'libawl-php' ]:
    ensure => present,
  }


  if $davical_domain == '' {
    fail("you have to set \$davical_domain for $fqdn!")
  }

  davical::config{$davical_domain: }

  if tagged(dbserver) {
    postgres::role { davical_app: ensure => present, password => $davicalapppassword }
    postgres::role { davical_dba: ensure => present, password => $davicaldbapassword }
    postgres::database {'davical':
        ensure => present, owner => davical_app, require => Postgres::Role[davical_dba]
    }
  }
}
