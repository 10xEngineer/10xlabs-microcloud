require 'spec_helper'

include TenxLabs::Definition

describe TenxLabs::Definition::Metadata do
	it "is derived from Base" do
		Metadata.should be < Base
	end

	it "resolves handler" do
		handler_klass = TenxLabs::Handlers::Chef

		metadata = TenxLabs::Definition::Metadata.new
		metadata.use handler_klass.name

		metadata.handler.should_not be_nil
		metadata.handler.class == handler_klass
	end
end