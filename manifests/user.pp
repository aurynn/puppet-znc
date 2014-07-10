# Define: znc::user
#
# Description:
#  This custom definition will create a stub file to allow ZNC users
#  to be added to the running config while not overwriting
#  any settings changed via the web interface.
#
# Parameters:
#  $admin: (true|false) describes whether a user is an admin user or not.
#
# Actions:
#   Installs a stub file with a default set of parameters in the users directory
#   This is a managed file-fragment directory that is also used to clean users
#   from the config file if necessary as well
#
# Requires:
#
# Sample Usage:
#   znc::user { 'jfryman': }
#
# This define is called directly
define znc::user(
  $timezone,
  $ensure = 'present',
  $admin  = 'false',
  $buffer = 500,
  $keepbuffer = 'false',
  $pass = '',
  $nickname = $name,
  $altnick = "${name}_",
  $ident = $name,
  $realname = $name,
  $maxnetworks = 1,
  $quitmsg = 'ZNC',
) {
  include znc::params
  include stdlib

  File {
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin'
  }
  # TODO: Default time zone.
  
  $filename = "${znc::params::zc_config_dir}/configs/users/${name}.conf"
  $network_path = "${znc::params::zc_config_dir}/configs/users/${name}/networks/"

  $header = "${filename}.head"

  if $ensure == 'present' {
    
    notice("${znc::params::zc_config_dir}/configs/users/${name}/")
    notice($network_path)
    notice("${znc::params::zc_config_dir}/users/${name}")

    file{"${znc::params::zc_config_dir}/configs/users/${name}/":
        ensure => directory
    } ->
    file{$network_path:
      ensure  => directory,
    }

    file{"${znc::params::zc_config_dir}/users/${name}":
        ensure  => directory,
        require => File["${znc::params::zc_config_dir}/users"]
    } ->
    file{"${znc::params::zc_config_dir}/users/${name}/networks":
        ensure  => directory
    }

    if $pass {
      $pass_hash = znc_password_hash($pass)
    }
    
    file{$header:
        ensure  => file,
        content => template('znc/configs/znc.conf.seed.erb')
    }
    
    exec { "collect-${name}-networks":
      command     => "cat $header ${network_path}/* > ${filename}",
      creates     => $filename,
      refreshonly => true
    }
    
    # Concats the closing </User> tag into the config file.
    exec{"close-${name}-config":
        command     => "echo '</User>' >> ${filename}",
        refreshonly => true,
        tag         => "znc-user"
    }
    
    # The order of operations for assembling the config file
    File[$header]
    ~> Exec["collect-${name}-networks"]
    ~> Exec["close-${name}-config"]
    
    # The concatenation for the network files has to occur
    # before we execute the collector for them.
    Concat <| tag == "znc-network-${user}" |>
    ~> Exec["collect-${name}-networks"]
    
  }
}
