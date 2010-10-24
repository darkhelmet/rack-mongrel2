require 'sinatra'
require 'yajl/json_gem'

get '*' do
  items = request.env.map do |k,v|
    "<li><strong>#{k}</strong>: #{v}</li>\n"
  end
  %Q{
    <html>
      <head>
        <title>Sinatra Mongrel2 Test</title>
      </head>
      <body>
        <h1>env</h1>
        <ul>
          #{items}
        </ul>
        <hr />
        <h1>Params</h1>
        #{params.to_json}
      </body>
    </html>
  }
end