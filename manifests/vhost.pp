define davical::config(){
  include ::davical
  file{"/etc/davical/${name}-conf.php":
    source => [ "puppet:///modules/site-davical/conf/${fqdn}/${name}-conf.php",
                "puppet:///modules/site-davical/conf/${name}-conf.php" ],
    require => Package['davical'],
    owner => root, group => apache, mode => 0640;
  }
}
