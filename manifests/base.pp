class davical::base {
  package{ [ 'davical', 'libawl-php' ]:
    ensure => present,
  }
  include perl::extensions::yaml
  
  file{'/etc/davical/administration.yml':
    source => [ "puppet:///modules/site-davical/conf/${fqdn}/administration.yml",
                "puppet:///modules/site-davical/conf/administration.yml" ],
    require => Package['davical'],
    owner => root, group => root, mode => 0640;
  }
}
