class postgres::params::package {
  $client = "postgresql$postgres::params::package_suffix"
  $server = "postgresql${postgres::params::package_suffix}-server"
  $devel = "postgresql${postgres::params::package_suffix}-devel"
}
