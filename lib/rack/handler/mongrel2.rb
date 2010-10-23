require 'mongrel2/connection'
require 'stringio'

module Rack
  module Handler
    class Mongrel2
      class << self
        def run(app, options = {})
          options = {
            :recv => 'tcp://127.0.0.1:9997' || ENV['RACK_MONGREL2_RECV'],
            :send => 'tcp://127.0.0.1:9996' || ENV['RACK_MONGREL2_SEND'],
            :uuid => ENV['RACK_MONGREL2_UUID']
          }.merge(options)
          raise ArgumentError.new('Must specify an :uuid or set RACK_MONGREL2_UUID') if options[:uuid].nil?

          conn = ::Mongrel2::Connection.new(options[:uuid], options[:recv], options[:send])

          running = true
          trap('SIGINT') do
            running = false
            conn.close
          end

          while running
            req = conn.recv
            next if req.disconnect?
            return unless running

            script_name = ENV['RACK_RELATIVE_URL_ROOT'] || req.headers['PATTERN'].split('(', 2).first.gsub(/\/$/, '')
            env = {
              'rack.version' => Rack::VERSION,
              'rack.url_scheme' => 'http', # Only HTTP for now
              'rack.input' => StringIO.new(req.body),
              'rack.errors' => $stderr,
              'rack.multithread' => true,
              'rack.multiprocess' => true,
              'rack.run_once' => false,
              'mongrel2.pattern' => req.headers['PATTERN'],
              'REQUEST_METHOD' => req.headers['METHOD'],
              'SCRIPT_NAME' => script_name,
              'PATH_INFO' => req.headers['PATH'].gsub(script_name, ''),
              'QUERY_STRING' => req.headers['QUERY']
            }

            env['SERVER_NAME'], env['SERVER_PORT'] = req.headers['host'].split(':', 2)
            req.headers.each do |key, val|
              unless key =~ /content_(type|length)/i
                key = "HTTP_#{key.upcase}"
              end
              env[key] = val
            end

            status, headers, rack_response = app.call(env)
            body = ''
            rack_response.each { |b| body << b }
            conn.reply(req, body, status, headers)
          end
        ensure
          conn.close if conn.respond_to?(:close)
        end
      end
    end
  end
end