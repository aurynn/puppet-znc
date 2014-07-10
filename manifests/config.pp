# Class: znc::config
#
# Description
#  This class is designed to set up the ZNC configuration after the package
#  has been deployed and the initscripts and users are set up.
#
# Parameters:
#   $auth_type: (plain|sasl). Will determine to use local auth or SASL auth.
#   $ssl: (true|false). To enable or disable SSL support. 
#   $ssl_cert: A path to an SSL certificate file.
#   $port: port to run ZNC on.
# 
# Actions:
#  - Sets up ZNC config concat element.
#  - Copies SSL cert into position, if provided.
#
# Requires:
#  This module has no requirements
#
# Sample Usage:
#  This module should not be called directly.
class znc::config(
  $auth_type            = undef,
  $ssl                  = undef,
  $ssl_cert             = undef,
  $port,
) {
  File {
    owner => $znc::params::zc_user,
    group => $znc::params::zc_group,
    mode  => '0600',
  }
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin'
  }

  file { $znc::params::zc_config_dir:
    ensure => directory,
  }
  file { "${znc::params::zc_config_dir}/configs":
    ensure => directory,
  }->
  file { "${znc::params::zc_config_dir}/configs/users":
     ensure  => directory,
  }
  file{"${znc::params::zc_config_dir}/users":
    ensure  => directory,
    require => File[$znc::params::zc_config_dir]
  }

  # Copies the SSL cert into place.
  # Not ideal, but workable.
  if $ssl and $ssl_cert {
    file { "${znc::params::zc_config_dir}/znc.pem":
      ensure => file,
      mode   => '0600',
      source => $ssl_cert,
    }
  }

  $config = "${znc::params::zc_config_dir}/configs/znc.conf"
  $user_path ="${znc::params::zc_config_dir}/configs/users"
  $config_base = "${config}.base"
    
  file{$config_base:
    ensure   => present,
    content  => template("znc/configs/znc.conf.header.erb")
  }

  exec { "collect-znc-users":
    command     => "cat $config_base ${user_path}/*.conf > ${config}",
    refreshonly => true
  }

  # If the base file changes, regenerate the config
  File[$config_base]
  ~> Exec["collect-znc-users"]

  # If any of the users have changed, regenerate the config.

  Exec <| tag == "znc-user" |>
  ~> Exec["collect-znc-users"]
  
}
