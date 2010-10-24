require 'sinatra'

get '*' do
  items = request.env.map do |k,v|
    "<li><strong>#{k}</strong>: #{v}</li>"
  end.join("\n")
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
        #{params}
      </body>
    </html>
  }
end