class postgres::client {
  require postgres
  package{'postgresql':
    ensure => present,
    name => $postgres::params::package::client,
  }
  if $use_shorewall {
    include shorewall::rules::out::postgres
  }
}
