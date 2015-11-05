$:.unshift(File.dirname(__FILE__))

require 'slim'
require 'lib/rack_app'
require 'lib/file_connection'
require 'lib/postgres_connection'
require 'app/models/user'

use Rack::Reloader, 0
run RackApp.new
