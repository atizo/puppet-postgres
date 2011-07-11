class postgres::server {
  require postgres::client
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
    creates => "$datapath_base/data/postgresql.conf",
    require => Package['postgresql-server'],
    before => [
      File["$datapath_base/data/pg_hba.conf"],
      File["$datapath_base/data/postgresql.conf"]
    ],
  }
  file{[
    "$datapath_base/data/postgresql.conf",
    "$datapath_base/data/pg_hba.conf",
  ]:}
  if $postgres::version {
    File["$datapath_base/data/postgresql.conf"]{
      prepend_source => [
        "puppet://$server/modules/site-postgres/$postgres::version/$fqdn/postgresql.conf",
        "puppet://$server/modules/site-postgres/$postgres::version/postgresql.conf",
      ]
    }
    File["$datapath_base/data/pg_hba.conf"]{
      prepend_source => [
        "puppet://$server/modules/site-postgres/$postgres::version/$fqdn/pg_hba.conf",
        "puppet://$server/modules/site-postgres/$postgres::version/pg_hba.conf",
      ]
    }
  }
  file{"$datapath_base/backups":
    ensure => directory,
    require => Package['postgresql-server'],
    owner => postgres, group => postgres, mode => 0700;
  }
  file{'/etc/cron.d/pgsql_backup.cron':
    source => "puppet://$server/modules/postgres/pgsql_backup.cron",
    require => File['/var/lib/pgsql/backups'],
    owner => root, group => 0, mode => 0600;
  }
  file{'/etc/cron.d/pgsql_vacuum.cron':
    source => "puppet://$server/modules/postgres/pgsql_vacuum.cron",
    require => Package['postgresql-server'],
    owner => root, group => 0, mode => 0600;
  }
}
