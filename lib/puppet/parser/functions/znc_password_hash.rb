require 'digest/sha2'
require 'puppet'

module Puppet::Parser::Functions
  newfunction(:znc_password_hash, :type => :rvalue) do |args|
    # Not an ideal salting algo, but works
    salt_source = ("A".."Z").map{|i| i} + \
              ("a".."z").map{|i| i} + \
              (0..9).map{|i| i} +
              ["+","(",")",'\\',"*","-"]

    salt = 20.times.map{ salt_source[ Random.rand( salt_source.length ) ] }.join("")
    hash = Digest::SHA2.new(256)
    hash << args[0] # password
    hash << salt
    return {"method" => "sha256",
     "salt" => salt,
     "hash" => hash.hexdigest
    }
  end
end
