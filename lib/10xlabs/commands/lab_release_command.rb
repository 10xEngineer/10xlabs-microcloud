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
		# FIXME validate lab name
		# FIXME validate lab definition
		lab_name = args.shift
		definition = args.shift

		# FIXME hardcoded - re-use config values
		options.default :endpoint => "http://localhost:8080" || ENV['MICROCLOUD']

		# TODO move to shared logic
		microcloud = TenxLabs::Microcloud.new options.endpoint

		begin
			res = microcloud.post_ext "/labs/#{lab_name}/versions/#{definition}/release", {}
			puts res.inspect

			puts res["message"]
		rescue => e
			abort e.to_s
		end
	end
end