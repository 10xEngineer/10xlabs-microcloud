require '10xlabs/definition/mixins/from_file'
require '10xlabs/definition/mixins/transform'

require '10xlabs/definition/base'
require '10xlabs/definition/metadata'
require '10xlabs/definition/vm'
require '10xlabs/handlers/chef'

require '10xlabs/definition/errors'

module TenxLabs
	module Definition
		class Builder
			def self.construct(definition_root, revision)
				metadata_rb = File.join(definition_root, 'metadata.rb')
				raise TenxLabs::Errors::InvalidDefinition "Missing metadata descriptor!" unless File.exists?(metadata_rb)

				metadata = TenxLabs::Definition::Metadata.new(nil, revision)
				metadata.from_file(metadata_rb)

				build_vms(definition_root, metadata)

				metadata
			end

			def self.build_vms(definition_root, metadata)
				vms_path = File.join(definition_root, metadata.vms_path, "*.rb")

				Dir.glob(vms_path).each do |file|
					metadata.from_file(file)
				end	
			end
		end
	end
end