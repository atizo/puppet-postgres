#
# postgres module
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Copyright 2011, Atizo AG
# Simon Josi simon.josi+puppet(at)atizo.com
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#
# Module is base on the one from the immerda project
# https://git.puppet.immerda.ch/module-pgsql
# as well on Luke Kanies 
# http://github.com/lak/puppet-postgres/tree/master
#

class postgres(
  use_pgdg = false
) {
  $version = $use_pgdg
  if $use_pgdg {
    class{'yum::repo::pgdg':
      version => $version,
    }
  }

  include postgres::params

  if $use_munin {
    include postgres::munin
  }
  if $use_shorewall {
    include shorewall::rules::postgres
  }
}
