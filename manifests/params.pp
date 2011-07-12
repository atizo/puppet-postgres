class postgres::params{
  if $postgres::version {
    $package_suffix = regsubst($postgres::version, '\.','', 'G')
    $service_suffix = "-$postgres::version"
    $datapath_suffix = "$postgres::version"
  }
  $datapath_base = "/var/lib/pgsql$datapath_suffix"
  $service = "postgresql$service_suffix"
  require postgres::params::package
}
