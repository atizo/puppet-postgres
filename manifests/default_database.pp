# create default database
# generate hashed password with:
# ruby -r'digest/md5' -e 'puts "md5" + Digest::MD5.hexdigest(ARGV[1] + ARGV[0])' USERNAME PASSWORD
define postgres::default_database(
  $ensure = present,
  $username = false,
  $password = false,
  $alter_public_owner = false
) {
  if $username {
    $real_username = $username
  } else {
    $real_username = $name
  }
  postgres::database{$name:
    ensure => $ensure,
    owner => $real_username,
    require => Service['postgresql'],
  }
  if $password {
    postgres::role{$real_username:
      password => $password,
      ensure => $ensure,
      before => Postgres::Database[$name],
    }
  } else {
    #Postgres::Role[$real_username] -> Postgres::Database[$name]
  }
  if $alter_public_owner and ! defined(Exec["postgres_set_public_schema_owner_to_$real_username"]) {
    exec{"postgres_set_public_schema_owner_to_$real_username":
      user => "postgres",
      unless => "psql -d '$name' -c '\\dn' | egrep -q '^ public +\\| $real_username'",
      command => "psql -d '$name' -c 'ALTER SCHEMA public OWNER TO $real_username'",
      require => Postgres::Database[$name],
    }
  }
}
