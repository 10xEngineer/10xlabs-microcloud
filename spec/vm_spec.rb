require 'spec_helper'

include TenxLabs::Definition

describe TenxLabs::Definition::Vm do
	it "is derived from Base" do
		Metadata.should be < Base
	end
end