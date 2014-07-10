define znc::user::network(
    $server,
    $port,
    $ssl,
    $user = '',
    $network = '',
    $ensure = 'present',
    $flood_burst = 4,
    $flood_rate = 1,
    $connect_enabled = 'true',
    $ident = 'ZNC',
) {
    include znc::params
    include stdlib
    
    if $user == '' or $network == '' {
       if $name =~ /@/ { 
         $contents = split($name, "@")
         $real_user = $contents[0]
         $real_network = $contents[1]
       }
       else {
          err("User and network not defined, and name does not contain @!")
       }
    } 
    else {
        $real_user = $user
        $real_network = $network
    }
    # Set up the file paths
    $path = "${znc::params::zc_config_dir}/configs/users/${real_user}/networks"
    $file = "${path}/${real_network}"

    # TODO: Timezone from a system fact.

    notice("${znc::params::zc_config_dir}/users/${real_user}/networks")
    notice("${znc::params::zc_config_dir}/users/${real_user}/networks/${real_network}")

    if $ensure == "present" {

        
        file{"${znc::params::zc_config_dir}/users/${real_user}/networks/${real_network}":
            ensure  => directory,
            require => File["${znc::params::zc_config_dir}/users/${real_user}/networks"]
        }

        concat{$file:
            tag     => "znc-network-${real_user}",
            require => File[$path]
        }
        
        concat::fragment{"${real_user}-${real_network}-start":
            target  => $file,
            content => template("znc/configs/znc.conf.user.network.erb"),
            order   => 25
        }
        concat::fragment{"${real_user}-${real_network}-end":
            target  => $file,
            content => "\n        </Network>\n",
            order   => 99
        }
        
        # All module fragments must be resolved before we can resolve the
        # main concat.
        # Also, the network concat must be finished before we concat into the
        # user concat object.
        # Concat::Fragment <| tag == "znc-${real_user}-${real_network}-module" |> -> 
        # Concat[$file]
    }
}
