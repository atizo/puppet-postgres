class postgres::params::package {
  require postgres::params
  $client = "postgresql$postgres::params::package_suffix"
  $server = "postgresql-server$postgres::params::package_suffix"
  $devel = "postgresql-devel$postgres::params::package_suffix"
}
