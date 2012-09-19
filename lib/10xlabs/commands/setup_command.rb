require 'logger'
require 'microcloud'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

command :setup do |c|
	c.description = "Setup microcloud client"

	c.action do |args, options|
		config_file = File.join(ENV["HOME"], ".microcloud")

		if File.exists?(config_file)
			abort "Default configuration file already exists: #{config_file}"
		else
			say "Running 'microcloud setup' for first time"
		end

		options.endpoint = ask("Your microcloud endpoint URL:")
		options.compute_pool = ask("Defalt compute resource pool:")

		# verify endpoint
		begin
			microcloud = TenxLabs::Microcloud.new options.endpoint

			microcloud.get_ext "/ping"

			config = {
				"endpoint" => options.endpoint,
				"compute_pool" => options.compute_pool
			}

			# write config file
			File.open(config_file, 'w') do |f|
				f.puts YAML.dump(config)
			end

			say "Setting stored in '#{config_file}'"
		rescue => e
			say "Unable to validate Microcloud environment"
			puts e.message
		end

	end
end