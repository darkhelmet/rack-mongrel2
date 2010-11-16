$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'mongrel2'
require 'mongrel2/connection'
require 'mongrel2/request'
require 'mongrel2/response'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
  
end
