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
      ensure => "/usr$postgres::params::binary_path_prefix/bin/pg_config",
      require => Package['postgresql-devel'],
    }
  }
}
