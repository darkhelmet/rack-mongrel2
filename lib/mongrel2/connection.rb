require 'ffi-rzmq'
require 'mongrel2/request'
require 'mongrel2/response'

module Mongrel2
  class Connection
    @context = nil

    def self.context
      @context ||= ZMQ::Context.new(1)
    end

    def initialize(uuid, sub, pub)
      @uuid, @sub, @pub = uuid, sub, pub

      # Connect to receive requests
      @reqs = self.class.context.socket(ZMQ::PULL)
      @reqs.connect(sub)

      # Connect to send responses
      @resp = self.class.context.socket(ZMQ::PUB)
      @resp.connect(pub)
      @resp.setsockopt(ZMQ::IDENTITY, uuid)
    end

    def recv
      msg = @reqs.recv_string(0)
      msg.nil? ? nil : Request.parse(msg)
    end

    def reply(req, body, status = 200, headers = {})
      resp = Response.new(@resp)
      resp.send_http(req, body, status, headers)
      resp.close(req) if req.close?
    end

    def close
      # I think I should be able to just close the context
      self.class.context.close rescue nil
    end
  end
end
