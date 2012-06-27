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
end
