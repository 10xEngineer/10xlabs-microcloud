require 'logger'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

#
# Get Lab's VMs
#
command :vms do |c|
	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# FIXME validate lab name
		lab_name = args.shift


		# TODO move to shared logic
		microcloud = TenxLabs::Microcloud.new options.endpoint

		begin
			res = microcloud.get "/labs/#{lab_name}/vms", {}

			puts res["message"]
		rescue => e
			abort e.to_s
		end




	end
end