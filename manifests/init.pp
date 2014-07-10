# Class: znc
#
# Description
#   This module is designed to install and manage ZNC, and IRC Bouncer
#
#   This module has been built and tested on RHEL systems.
#
# Parameters:
#   $auth_type: (plain|sasl). Will determine to use local auth or SASL auth.
#   $ssl: (true|false). Will autogen a SSL certificate.
#   $ssl_source: puppet:///path/to/server.pem
#   $port: port to run ZNC on.
#   $organizationName: Org Name for SSL Self Signed Cert
#   $localityName: City for SSL Self Signed Cert
#   $stateOrProvinceName: State or Province for SSL Self Signed Cert
#   $countryName: Country for SSL Self Signed Cert
#   $emailAddress: Admin email for SSL Self Signed Cert
#   $commonName: Common Name for SSL Self Signed Cert
#   
# Actions:
#   This module will install the ZNC and prep it to connect
#   to a local IRC server. Per-user settings can be reconfigured.
#
# Requires:
#  - An IRC server to connect to.
#  - Class[stdlib]. This is Puppet Labs standard library to include additional methods for use within Puppet. [https://github.com/puppetlabs/puppetlabs-stdlib]
# 
# Sample Usage:
#  class { 'znc': 
#    ssl                 => 'true', 
#    port                => 6667
#  }
class znc(
  $auth_type           = $znc::params::zc_auth_type,
  $ssl_cert            = undef,
  $ssl                 = $znc::params::zc_ssl,
  $port                = $znc::params::zc_port
) inherits znc::params {
  include stdlib

  ### Begin Flow Logic ###
  anchor { 'znc::begin': }
  -> class { 'znc::package': }
  -> class { 'znc::system': }
  -> class { 'znc::config': 
       auth_type           => $auth_type,
       ssl                 => $ssl,
       ssl_cert            => $ssl_cert,
       port                => $port,
     }
  ~> class { 'znc::service': }
  -> anchor { 'znc::end': }
}
