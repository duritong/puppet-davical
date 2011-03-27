define davical::vhost(
  $ensure = 'present',
  $domainalias = 'absent',
  $ssl_mode = 'force',
  $monitor_url = 'absent'
){
  include ::davical
  file{"/etc/davical/${name}-conf.php":
    source => [ "puppet:///modules/site-davical/conf/${fqdn}/${name}-conf.php",
                "puppet:///modules/site-davical/conf/${name}-conf.php" ],
    require => Package['davical'],
    owner => root, group => apache, mode => 0640;
  }

  apache::vhost::php::standard{$name:
    ensure => $ensure,
    domainalias => $domainalias,
    manage_docroot => false,
    path => '/usr/share/davical/htdocs/',
    logpath => $operatingsystem ? {
      gentoo => '/var/log/apache2/',
      default => '/var/log/httpd'
    },
    manage_webdir => false,
    path_is_webdir => true,
    ssl_mode => $ssl_mode,
    template_partial => 'davical/vhost/php_stuff.erb',
    require => Package['davical'],
  }

  if $use_nagios {
    $real_monitor_url = $monitor_url ? {
      'absent' => $name,
      default => $monitor_url,
    }
    nagios::service::http{"${real_monitor_url}":
      ensure => $ensure,
      ssl_mode => $ssl_mode,
    }
  }
}
