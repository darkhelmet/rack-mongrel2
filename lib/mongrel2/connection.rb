require 'zmq'
require 'mongrel2/request'
require 'mongrel2/response'

module Mongrel2
  class Connection
    CTX = ZMQ::Context.new(1)

    def initialize(ident, sub, pub, block = true)
      @ident, @sub, @pub, @block = ident, sub, pub, block

      # Connect to receive requests
      @reqs = CTX.socket(ZMQ::UPSTREAM)
      @reqs.connect(sub)

      # Connect to send responses
      @resp = CTX.socket(ZMQ::PUB)
      @resp.connect(pub)
      @resp.setsockopt(ZMQ::IDENTITY, ident)
    end

    def recv
      Request.parse(@reqs.recv)
    end

    def reply(req, body, status = 200, headers = {})
      Response.new(@resp).send_http(req, body, status, headers)
    end

    def close
      @reqs.close rescue nil
      @resp.close rescue nil
    end
  end
end