$:.unshift(File.dirname(__FILE__))

require 'rack'
require 'startup'

use Rack::Reloader, 0
run Rack::Cascade.new([Rack::File.new("public/assets"), RackApp])
