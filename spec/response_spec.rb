require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Mongrel2::Response" do
  before(:each) do
    @req = double()
    @resp = double()
    @response = Response.new(@resp)
  end
  
  it "should work" do
    @req.should_receive(:uuid) {"UUID"}
    @req.should_receive(:conn_id) {"CONN_ID"}
    
    aoeu = '%s %d:%s, %s' % [uuid, conn_id.size, conn_id, data]
    @resp.should_receive(:send_string).with(aoeu)
    
    @response.send_http(@req, "Boo!", 200, {})
  end
end