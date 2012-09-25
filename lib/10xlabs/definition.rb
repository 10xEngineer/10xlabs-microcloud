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
			def self.construct(definition_root)
				metadata_rb = File.join(definition_root, 'metadata.rb')
				raise TenxLabs::Errors::InvalidDefinition "Missing metadata descriptor!" unless File.exists?(metadata_rb)

				metadata = TenxLabs::Definition::Metadata.new
				metadata.from_file(metadata_rb)

				build_vms(metadata)

				metadata
			end

			def self.build_vms(metadata)
				vms_path = nil
				if metadata.vms_path.match /^\//
				  vms_path = File.join(metadata.vms_path, "*.rb")
				else
				  vms_path = File.join(base_dir, metadata.vms_path, "*.rb")
				end

				Dir.glob(vms_path).each do |file|
					vm = TenxLabs::Definition::Vm.new
					vm.from_file(file)

					metadata.add_vm(vm)
				end	
			end
		end
	end
end