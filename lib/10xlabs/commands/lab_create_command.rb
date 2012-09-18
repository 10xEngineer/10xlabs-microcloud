require 'logger'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

#
# Create new lab
#
# Usage:
#
# microcloud-lab create LAB_NAME 
# microcloud-lab create LAB_NAME --source ./
# microcloud-lab create LAB_NAME --source git://github.com/10xEngineer/wip-lab-definition-basicvm.git
#
# TODO how to specify source authorization
# TODO config - resource pool
# TODO support for attributes
#
command :create do |c|
	c.description = "Create new lab"

	c.option '--source SOURCE', String, 'Lab source (lab URL/git repository/path)'
	c.option '--compile_kit KIT', String, 'Specify compile kit to use'
	c.option '--compute-pool POOL', String, 'Compute resource pool to use (overrides config default)'

	c.action do |args, options|
		# TODO verify lab_name
		lab_name = args.shift

		# FIXME hardcoded - re-use config values
		options.default :compute_pool => "xxxtest"
		options.default :endpoint => "http://localhost:8080" || ENV['MICROCLOUD']

		# TODO move to shared logic
		microcloud = TenxLabs::Microcloud.new options.endpoint

		data = {
			:name => lab_name,
			:pools => {
				:compute => options.compute_pool
			}
		}

		begin
			res = microcloud.post_ext "/labs", data

			puts "Lab '#{res["name"]}' created."
			puts res["repo"]
		rescue => e
			abort e.to_s
		end
	end
end