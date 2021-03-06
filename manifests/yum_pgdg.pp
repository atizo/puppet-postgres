class postgres::yum_pgdg inherits yum::repo::dist {
  include postgres::devel
  class{'yum::repo::pgdg':
    version => $postgres::version,
    before => [
      Class['postgres::client'],
      Class['postgres::server'],
      Class['postgres::devel'],
    ],
  }
  Yum::Repo[
    'centos-base',
    'centos-updates'
  ]{
    exclude => 'postgresql*',
    before => [
      Class['postgres::client'],
      Class['postgres::server'],
      Class['postgres::devel'],
    ],
  }
}
