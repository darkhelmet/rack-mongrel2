require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Mongrel2::Request" do
  
  it "should parse a netstring and ignore the contents of the netstring as well as the trailing comma" do
    netstring = "9:aoeu:snth,"
    result = Mongrel2::Request.parse_netstring(netstring)
    result.length.should == 2
    result[0].length.should == 9
    result[0].should eql("aoeu:snth")
  end
  
  it "should parse a netstring made up of multiple netstrings" do
    netstring = "9:aoeu:snth,16:aeou snth qwerty,"
    result = Mongrel2::Request.parse_netstring(netstring)
    result.length.should == 2
    result[0].length.should == 9
    result[0].should eql("aoeu:snth")
    result[1].length.should == 20
    result[1].should eql("16:aeou snth qwerty,")
  end
  
  it "should fail if the netstring does not end in a comma" do
    expect{Mongrel2::Request.parse_netstring("3:foo")}.to raise_error(NameError)
  end
  
  it "should parse a Mongrel2 message and have all parts populated" do
    netstring = "UUID CON PATH 232:{\"PATH\":\"/\",\"user-agent\":\"curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3\",\"host\":\"localhost:6767\",\"accept\":\"*/*\",\"x-forwarded-for\":\"::1\",\"METHOD\":\"GET\",\"VERSION\":\"HTTP/1.1\",\"URI\":\"/\",\"PATTERN\":\"/\"},0:,"
    r = Mongrel2::Request.parse(netstring)
    r.should_not be_nil
    r.uuid.should eql("UUID")
    r.conn_id.should eql("CON")
    r.path.should eql("PATH")
    r.body.length.should == 0
    r.headers.length.should == 9
    r.headers["PATH"].should eql("/")
    r.headers["user-agent"].should eql("curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3")
    r.headers["host"].should eql("localhost:6767")
    r.headers["accept"].should eql("*/*")
    r.headers["x-forwarded-for"].should eql("::1")
    r.headers["METHOD"].should eql("GET")
    r.headers["VERSION"].should eql("HTTP/1.1")
    r.headers["URI"].should eql("/")
    r.headers["PATTERN"].should eql("/")
  end
end