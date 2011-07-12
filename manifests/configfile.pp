define postgres::configfile(
  $ensure = present,
  $prepend_source = []
) {
  $basename = basename($name)
  file{$name:
    ensure => $ensure,
    notify => Service['postgresql'],
    require => Package['postgresql-server'],
    source => [
      "puppet://$server/modules/site-postgres$postgres::params::datapath_suffix/$fqdn/$basename",
      "puppet://$server/modules/site-postgres$postgres::params::datapath_suffix/$basename",
      "puppet://$server/modules/postgres$postgres::params::datapath_suffix/$basename",
      "puppet://$server/modules/site-postgres/$fqdn/$basename",
      "puppet://$server/modules/site-postgres/$basename",
      "puppet://$server/modules/postgres/$basename",
    ],
    owner => postgres, group => postgres, mode => 0600;
  }
}
