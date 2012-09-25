require 'spec_helper'

describe TenxLabs::Definition::Base do
	it "has method from_file" do
		metadata = TenxLabs::Definition::Metadata.new
		metadata.kind_of?(TenxLabs::Mixin::FromFile).should be_true
	end

	it "has method to_json " do
		metadata = TenxLabs::Definition::Metadata.new
		metadata.kind_of?(TenxLabs::Mixin::ObjectTransform).should be_true
	end	
end