define davical::config(){
  file{"/etc/davical/${name}-conf.php":
    source => [ "puppet://$server/files/davical/conf/${fqdn}/${name}-conf.php",
                "puppet://$server/files/davical/conf/${name}-conf.php" ],
    require => Package['davical'],
    owner => root, group => apache, mode => 0640;
  }
}
