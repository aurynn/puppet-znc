# Class: znc::system
#
# Description
#  This class is designed to configure the system to use ZNC after packages have been deployed
#
# Parameters:
# 
# Actions:
#  - Sets up ZNC initscript
#  - Creates ZNC system user
#  - Creates ZNC group
#
# Requires:
#  This module has no requirements
#
# Sample Usage:
#  This module should not be called directly.
class znc::system() {

  file { '/etc/init.d/znc':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template("znc/etc/init.d/znc.${znc::params::zc_suffix}.erb"),
  }
  # Create the ZNC system user

  user { $znc::params::zc_user:
    ensure     => present,
    uid        => $znc::params::zc_uid,
    gid        => $znc::params::zc_gid,
    shell      => '/bin/bash',
    comment    => 'ZNC Service Account',
    managehome => 'true',
  }
  group { $znc::params::zc_group:
    ensure => present,
    gid    => $znc::params::zc_gid,
  }

}
