class postgres::server {
  Class['postgres::server'] <- Class['postgres']
  Class['postgres::server'] <- Class['postgres::client']
  if $use_pgdg {
    Class['postgres::server'] <- Class['postgres::yum_pgdg']
  }
  include postgres::client
  package{'postgresql-server':
    ensure => present,
    name => $postgres::params::package::server,
  }
  service{'postgresql':
    enable => true,
    ensure => running,
    hasstatus => true,
    name => $postgres::params::service,
    require => Package['postgresql-server'],
  }
  exec{'initialize_postgres_database':
    command => "/etc/init.d/$postgres::params::service initdb",
    creates => "$postgres::params::datapath_base/data/postgresql.conf",
    require => Package['postgresql-server'],
    before => [
      Service['postgresql'],
      File["$postgres::params::datapath_base/data/pg_hba.conf"],
      File["$postgres::params::datapath_base/data/postgresql.conf"],
    ],
  }
  postgres::configfile{[
    "$postgres::params::datapath_base/data/postgresql.conf",
    "$postgres::params::datapath_base/data/pg_hba.conf",
  ]:}
  file{"$postgres::params::datapath_base/backups":
    ensure => directory,
    require => Package['postgresql-server'],
    owner => postgres, group => postgres, mode => 0700;
  }
  file{'/etc/cron.d/pgsql_backup.cron':
    content => template('postgres/pgsql_backup.cron.erb'),
    require => File["$postgres::params::datapath_base/backups"],
    owner => root, group => 0, mode => 0600;
  }
  file{'/etc/cron.d/pgsql_vacuum.cron':
    content => template('postgres/pgsql_vacuum.cron.erb'),
    require => Package['postgresql-server'],
    owner => root, group => 0, mode => 0600;
  }
}
