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
    require => Postgres::Role[$real_username],
  }
  if $password {
    postgres::role{$real_username:
      password => $password,
      ensure => $ensure,
    }
  }
  if $alter_public_owner {
    exec{"postgres_set_public_schema_owner_to_${real_username}_for_$name":
      user => "postgres",
      unless => "psql -d '$name' -c '\\dn' | egrep -q '^ public +\\| $real_username'",
      command => "psql -d '$name' -c 'ALTER SCHEMA public OWNER TO $real_username'",
      require => [
        Postgres::Role[$real_username],
        Postgres::Database[$name],
      ],
    }
  }
}
