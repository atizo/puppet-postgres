class postgres::devel {
  Class['postgres::devel'] <- Class['postgres']
  package{'postgresql-devel':
    ensure => present,
    name => $postgres::params::package::devel,
  }
}
