require 'logger'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

#
# Release Lab Definition
#
command :release do |c|
	c.description = "Release (deploy) lab definition"

	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# FIXME validate lab name
		# FIXME validate lab definition
		lab_name = args.shift
		definition = args.shift

		begin
			res = TenxLabs::CLI.microcloud.post_ext "/labs/#{lab_name}/versions/#{definition}/release", {}
			puts res.inspect

			puts res["message"]
		rescue => e
			abort e.to_s
		end
	end
end