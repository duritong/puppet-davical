define davical::vhost(
  $ensure = 'present',
  $domainalias = 'absent',
  $ssl_mode = 'force',
  $logmode = 'default',
  $mod_security = false,
  $monitor_url = 'absent',
  $run_mode = 'normal',
  $run_uid = 'absent',
  $run_gid = 'absent'
){
  include ::davical
  file{"/etc/davical/${name}-conf.php":
    source => [ "puppet:///modules/site_davical/conf/${::fqdn}/${name}-conf.php",
                "puppet:///modules/site_davical/conf/${name}-conf.php" ],
    require => Package['davical'],
    owner => root, mode => 0640;
  }

  if ($run_mode == 'fcgid'){
    if (($run_uid == 'absent') or ($run_gid == 'absent')) { fail("Need to configure \$run_uid and \$run_gid if you want to run Phpmyadmin::Vhost[${name}] as fcgid.") }

    user::managed{$name:
      ensure => $ensure,
      uid => $run_uid,
      gid => $run_gid,
      shell => $::operatingsystem ? {
        debian => '/usr/sbin/nologin',
        ubuntu => '/usr/sbin/nologin',
        default => '/sbin/nologin'
      },
      before => Apache::Vhost::Php::Standard[$name],
    }
    File["/etc/davical/${name}-conf.php"]{
      group => $name
    }
  } else {
    File["/etc/davical/${name}-conf.php"]{
      group => apache
    }
  }

  apache::vhost::php::standard{$name:
    ensure => $ensure,
    domainalias => $domainalias,
    manage_docroot => false,
    path => '/usr/share/davical/htdocs',
    logpath => $::operatingsystem ? {
      gentoo => '/var/log/apache2',
      default => '/var/log/httpd'
    },
    run_mode => $run_mode,
    run_uid => $name,
    run_gid => $name,
    logmode => $logmode,
    manage_webdir => false,
    path_is_webdir => true,
    ssl_mode => $ssl_mode,
    php_settings => {
      safe_mode         => 'Off',
      include_path      => '/usr/share/awl/inc',
      magic_quotes_gpc  => 0,
      register_globals  => 'On',
      open_basedir      => "/etc/davical:/usr/share/davical:/var/www/session.save_path/${name}/:/var/www/upload_tmp_dir/${name}/:/usr/share/awl/inc",
      error_reporting   => "E_ALL & ~E_NOTICE",
      default_charset   => "utf-8"
    },
    mod_security => $mod_security,
    require => Package['davical'],
  }

  if hiera('use_nagios',false) {
    $real_monitor_url = $monitor_url ? {
      'absent' => $name,
      default => $monitor_url,
    }
    nagios::service::http{$real_monitor_url:
      ensure => $ensure,
      ssl_mode => $ssl_mode,
    }
  }
}
