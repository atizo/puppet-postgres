class postgres::devel {
  require postgres
  package{'postgresql-devel':
    ensure => present,
    name => $postgres::params::package::devel,
  }
}
