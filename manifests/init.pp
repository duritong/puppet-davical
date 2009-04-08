# modules/davical/manifests/init.pp - manage davical stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

# modules_dir { "davical": }

class davical {
    case $operatingsystem {
        gentoo: { include davical::gentoo }
        default: { include davical::base }
    }
}

class davical::base {
    # needs a few apache, settings ... ????


  if tagged(dbserver) {
    postgres::role { davical_app: ensure => present, password => $davicalapppassword }
    postgres::role { davical_dba: ensure => present, password => $davicaldbapassword }
    postgres::database {
        ["davical"]:
                ensure => present, owner => davical_app, require => Postgres::Role[davical_dba]
        }
  }

}

class davical::gentoo inherits davical::base {
    Package[davical]{
        category => 'some-category',
    }

    #conf.d file if needed
    # needs module gentoo
    #gentoo::etcconfd { davical: require => "Package[davical]", notify => "Service[davical]"}
}
