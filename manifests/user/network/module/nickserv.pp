define znc::user::network::module::nickserv(
    $password,
    $user = '',
    $network = '',
    $ensure = 'present'
) {
    include znc::params
    File {
        owner => $znc::params::zc_user,
        group => $znc::params::zc_group,
        mode  => '0600',
    }
    
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

    $file = "${znc::params::zc_config_dir}/configs/users/${real_user}/networks/${real_network}"

    $path = "${znc::params::zc_config_dir}/users/${real_user}/networks/${real_network}/moddata/nickserv"

    if $ensure == 'present' {

        notice("${znc::params::zc_config_dir}/users/${real_user}/networks/${real_network}/moddata/")
        notice($path)
        notice("${path}/.registry")
        notice($file)

        file{"${znc::params::zc_config_dir}/users/${real_user}/networks/${real_network}/moddata/":
            ensure  => directory,
            require => File["${znc::params::zc_config_dir}/users/${real_user}/networks/${real_network}"]
        } ->
        file {$path:
            ensure => directory
        } ->
        file {"${path}/.registry":
            content => template("znc/configs/modules/nickserv.erb"),
        }

        concat::fragment {"${real_user}-${real_network}-nickserv":
            target  => $file,
            order   => "98", # just before the end
            tag     => "znc-${real_user}-${real_network}-module",
            content => "        LoadModule = nickserv <hidden>\n"
        }
    }
}

