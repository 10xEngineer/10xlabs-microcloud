require 'spec_helper'
require 'uri'

describe TenxLabs::Microcloud do
  context "infrastructure" do
    before do
      @hostname = "localhost"
      @port = 8080
      @uri = URI::HTTP.build({
        :host => @hostname, 
        :port => @port
      })

      @microcloud = TenxLabs::Microcloud.new(@uri.to_s)
    end

    it "should use specified" do
      TenxLabs::Microcloud.base_uri.should == @uri.to_s
    end
  end

  context "resource paths" do
    before do
      @microcloud = TenxLabs::Microcloud.new("http://localhost:8080")
    end

    it "build resource root path" do
      @microcloud.resource_path(:vm).should == "/vms"
    end

    it "should pluralize resource" do
      @microcloud.resource_path(:vm, 1).should == "/vms/1"
    end

    it "should build nested resource path" do
      @microcloud.nested_resources_paths([[:node, 1], [:vm, 2]]).should == "/nodes/1/vms/2"
      @microcloud.nested_resources_paths([[:node, 1], [:vm, 2, "notify"]]).should == "/nodes/1/vms/2/notify"
    end
  end

  context "requests" do
    before do
      @microcloud = TenxLabs::Microcloud.new("http://localhost:8080")
    end

    def canned_response
      response = double("response")
      response.stub(:response) {Net::HTTPOK.new('1.1', 200, 'OK')}
      response.stub(:parsed_response) {{}}

      response
    end

    it "performs GET request" do
      TenxLabs::Microcloud.should_receive(:get).once.with(kind_of(String), kind_of(Hash)).and_return(canned_response)

      @microcloud.get(:vms, 1)
    end

    it "performs POST request" do
      TenxLabs::Microcloud.should_receive(:post).once.with(kind_of(String), kind_of(Hash)).and_return(canned_response)

      @microcloud.post(:vms, 1, {})
    end

  end
end
