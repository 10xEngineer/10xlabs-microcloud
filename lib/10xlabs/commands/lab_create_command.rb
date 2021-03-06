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
	c.option '--pool-compute POOL', String, 'Compute resource pool to use (overrides config default)'

	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# TODO verify lab_name
		lab_name = args.shift

		# make request
		data = {
			:name => lab_name,
			:pools => {
				:compute => options.compute_pool
			}
		}

		begin
			res = TenxLabs::CLI.microcloud.post_ext "/labs", data

			puts "Lab '#{res["name"]}' created."
			puts res["repo"]
		rescue => e
			abort e.to_s
		end
	end
end