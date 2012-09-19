require 'logger'
require 'terminal-table'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

command :destroy do |c|
	c.description = "Destroy specified lab"

	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# TODO validate lab
		lab_name = args.shift

		begin
			res = TenxLabs::CLI.microcloud.delete_ext "/labs/#{lab_name}"
		rescue => e
			abort e.to_s			
		end
	end
end