define znc::ssl(
  $target,
  $organizationName    = undef,
  $localityName        = undef,
  $stateOrProvinceName = undef,
  $countryName         = undef,
  $emailAddress        = undef,
  $commonName          = undef,
) {

    # Generates a self-signed SSL certificate.
    file { "${znc::params::zc_config_dir}/ssl":
      ensure => directory,
      mode   => '0600',
    }
    file { "${znc::params::zc_config_dir}/bin":
      ensure => directory,
    }
    file { "${znc::params::zc_config_dir}/bin/generate_znc_ssl":
      ensure  => file,
      mode    => '0755',
      content => template('znc/bin/generate_znc_ssl.erb'),
      require => File["${znc::params::zc_config_dir}/ssl"],
    }
    file { "${znc::params::zc_config_dir}/znc.pem":
      ensure  => 'file',
      mode    => '0600',
      require => Exec['create-self-signed-znc-ssl'],
    }
    exec { 'create-self-signed-znc-ssl':
      command => "${znc::params::zc_config_dir}/bin/generate_znc_ssl",
      creates => "${znc::params::zc_config_dir}/znc.pem",
    }

}
