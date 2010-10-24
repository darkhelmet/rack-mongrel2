$: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift(File.expand_path('.')) # Ruby 1.9 doesn't have . in the load path...

require 'rack/handler/mongrel2'
require 'app'

Rack::Handler::Mongrel2.run Sinatra::Application, :uuid => 'sinatra', :block => true
exit(0)