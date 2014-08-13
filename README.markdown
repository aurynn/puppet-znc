# ZNC Module

James Fryman <james@frymanet.com>

# Contributors

Aurynn Shaw <self@aurynn.com>

This module manages ZNC from within Puppet

# Quick Start

Install and bootstrap a ZNC instance, allowing configuration of users and
nickserv passwords to happen within the Puppet manifest directly.

# Requirements

Puppet Labs Standard Library
- http://github.com/puppetlabs/puppetlabs-stdlib

Puppet Labs Concat library
- http://github.com/puppetlabs/puppetlabs-concat

# Fork

Forked from jfryman upstream to add support for Puppet 3.6 and user networks
in ZNC, and moving some custom/handrolled concat actions to upstream concat library.

# Example

<pre>
  class { 'znc':
    ssl                 => 'true',
    ssl_cert            => "/path/to/cert",
    port                => 1234
  }

  znc::user{"aurynn":
    admin       => 'true',
    quitmsg     => 'quitmsg',
    realname    => "realname",
    timezone    => "Pacific/Auckland",
    pass        => "password",
  }

  znc::user::network{"aurynn@freenode":
      server => "irc.freenode.net",
      ssl    => "true",
      port   => 6697,
      ident  => 'ZNC'
  }
  znc::user::network::module::nickserv{"aurynn@freenode":
    password => "password"
  }



</pre>
