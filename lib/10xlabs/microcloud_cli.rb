require 'yaml'
require 'commander'
require 'commander/delegates'

module TenxLabs
	class CLI
		@@config = {}
		@@config_file = File.join(ENV["HOME"], ".microcloud")
		@@config_defaults = [:endpoint, :compute_pool]

		class << self
			attr_accessor :config_file
		end

		@@microcloud_inst = nil

		def self.run
			yield
		end

		def self.config
			if @@config.empty?
				unless File.exists? @@config_file
					abort "No configuration available. Please run 'microcloud config' first."
				end

				config = YAML::load(File.open(@@config_file))

				# convert keys to symbols
				@@config = config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
			end

			@@config
		end

		def self.populate_defaults(options, prefix = nil)
			@@config_defaults.each do |key_name|
				options.default key_name => @@config[key_name.to_s]
			end
		end

		def self.microcloud
			unless @@microcloud_inst
				@@microcloud_inst = TenxLabs::Microcloud.new @@config[:endpoint]
			end
			
			return @@microcloud_inst
		end
	end
end

#
# snippet from commander:lib/commander/import.rb needed when manually calling
# run! instead of relying on at_exit { run! } (sic!).
#
include Commander::UI
include Commander::UI::AskForClass
include Commander::Delegates

$terminal.wrap_at = HighLine::SystemExtensions.terminal_size.first - 5 rescue 80 if $stdin.tty?

