class davical::base {
  package{ [ 'davical', 'libawl-php' ]:
    ensure => present,
  }
  include perl::extensions::yaml
  include perl::extensions::dbd_pg
  
  file{'/etc/davical/administration.yml':
    source => [ "puppet:///modules/site_davical/conf/${::fqdn}/administration.yml",
                "puppet:///modules/site_davical/conf/administration.yml" ],
    require => Package['davical'],
    owner => root, group => root, mode => 0640;
  }
}
