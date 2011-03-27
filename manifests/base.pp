class davical::base {
  package{ [ 'davical', 'libawl-php' ]:
    ensure => present,
  }
  include perl::extensions::yaml
}
