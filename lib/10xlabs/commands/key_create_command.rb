require 'logger'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

command :create do |c|
	c.description = "Create a new SSH keypair"

	c.option '--file FILE', String, 'Save private key into the specified destination file'

	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# TODO validate name
		key_name = args.shift

		data = {
			:name => key_name
		}

		begin
			res = TenxLabs::CLI.microcloud.post_ext "/keys", data

			puts "Key '#{res["name"]}' created with fingerprint #{res["fingerprint"]}"

			unless options.file
				puts
				puts res["identity"]
			else
				File.open(options.file, 'w') do |f|
					f.puts res["identity"]
				end

				puts "Saved as '#{options.file}'"
			end
		rescue => e
			abort e.to_s
		end

	end	
end