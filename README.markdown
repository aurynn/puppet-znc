# ZNC Module

James Fryman <james@frymanet.com>

# Contributors

Aurynn Shaw <self@aurynn.com>

This module manages ZNC from within Puppet

# Quick Start

Install and bootstrap a ZNC instance

# Requirements

Puppet Labs Standard Library
- http://github.com/puppetlabs/puppetlabs-stdlib

Puppet Labs Concat library
- http://github.com/puppetlabs/puppetlabs-concat

# Fork

Forked from jfryman upstream to add support for Puppet 3.6 and user networks
in ZNC.
Moving custom/handrolled concat actions to upstream concat library.


<pre>
  class { 'znc':
    ssl                 => 'true',
    organizationName    => 'Fryman and Associates, Inc',
    localityName        => 'Nashville',
    stateOrProvinceName => 'TN',
    countryName         => 'US',
    emailAddress        => 'james@frymanandassociates.net',
    commonName          => 'irc.frymanandassociates.net',
  }
</pre>
