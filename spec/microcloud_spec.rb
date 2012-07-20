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
end
