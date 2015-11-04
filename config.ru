require 'slim'
require_relative 'lib/rack_app'

use Rack::Reloader, 0

run RackApp.new
