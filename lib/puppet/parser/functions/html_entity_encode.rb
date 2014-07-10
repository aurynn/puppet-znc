require 'puppet'
require 'htmlentities'

module Puppet::Parser::Functions
  newfunction(:html_entity_encode, :type => :rvalue) do |args|
    HTMLEntities.new.encode args[0]
  end
end
