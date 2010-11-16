require 'ffi-rzmq'
require 'mongrel2/request'
require 'mongrel2/response'

module Mongrel2
  class Connection
    CTX = ZMQ::Context.new(1)

    def initialize(uuid, sub, pub, block = true)
      @uuid, @sub, @pub, @block = uuid, sub, pub, block

      # Connect to receive requests
      @reqs = CTX.socket(ZMQ::UPSTREAM)
      @reqs.connect(sub)

      # Connect to send responses
      @resp = CTX.socket(ZMQ::PUB)
      @resp.connect(pub)
      @resp.setsockopt(ZMQ::IDENTITY, uuid)
    end

    def recv
      msg = @reqs.recv_string(@block ? 0 : ZMQ::NOBLOCK)
      msg.nil? ? nil : Request.parse(msg)
    end

    def reply(req, body, status = 200, headers = {})
      Response.new(@resp)send_http(req, body, status, headers)
    end

    def close
      # I think I should be able to just close the context
      @resp.send_string('%s 0:, %s' % [@uuid, ""])
      CTX.close rescue nil
    end
  end
end