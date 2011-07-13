class postgres::devel {
  Class['postgres::devel'] <- Class['postgres']
  if $use_pgdg {
    Class['postgres::devel'] <- Class['postgres::yum_pgdg']
  }
  package{'postgresql-devel':
    ensure => present,
    name => $postgres::params::package::devel,
  }
  if $postgres::version {
    file{'/usr/bin/pg_config':
      ensure => "/usr/bin$postgres::params::binary_suffix/pg_config",
      require => Package['postgres::devel'],
    }
  }
}
