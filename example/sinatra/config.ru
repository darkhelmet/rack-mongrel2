$: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'rack/handler/mongrel2'
require 'app'

Rack::Handler::Mongrel2.run Sinatra::Application