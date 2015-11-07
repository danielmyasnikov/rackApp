$:.unshift(File.dirname(__FILE__))

require 'slim'
require 'lib/rack_grunt'
require 'lib/rack_app'
require 'lib/connections/file_connection'
require 'lib/connections/postgres_connection'
require 'lib/connections/rethinkdb_connection'
require 'app/models/user'

use Rack::Reloader, 0
run Rack::Cascade.new([Rack::File.new("public/assets"), RackApp])
