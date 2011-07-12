define postgres::configfile(
  $ensure = present,
  $prepend_source = []
) {
  $basename = basename($name)
  file{$name:
    ensure => $ensure,
    notify => Service['postgresql'],
    require => Package['postgresql-package'],
    source => $prepend_source + [
      "puppet://$server/modules/site-postgres/$fqdn/$basename",
      "puppet://$server/modules/site-postgres/$basename",
      "puppet://$server/modules/postgres/$basename.$operatingsystem",
      "puppet://$server/modules/postgres/$basename.conf",
    ],
    owner => postgres, group => postgres, mode => 0600;
  }
}