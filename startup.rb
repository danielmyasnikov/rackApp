$:.unshift(File.dirname(__FILE__))
require 'lib/rack_app'
require 'lib/connections/file_connection'
require 'lib/connections/postgres_adapter'
require 'lib/connections/rethinkdb_connection'
require 'app/models/member.rb'
