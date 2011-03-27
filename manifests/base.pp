class davical::base {
  package{ [ 'davical', 'libawl-php' ]:
    ensure => present,
  }
}
