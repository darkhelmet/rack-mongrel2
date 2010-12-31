require 'sinatra'
require 'yajl/json_gem'

get '*' do
  sleep(5)
  request.env.to_json
end