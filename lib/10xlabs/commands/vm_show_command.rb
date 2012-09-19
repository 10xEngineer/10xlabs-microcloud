require 'logger'
require 'terminal-table'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

command :show do |c|
	c.description = "Display VM details"

	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# TODO validate VM uuid
		vm_uuid = args.shift

		begin
			res = TenxLabs::CLI.microcloud.get_ext "/vms/#{vm_uuid}"

			rows = []
			rows << ['uuid', res["uuid"]]
			rows << ['name', res["vm_name"]]
			rows << ['state', res["state"]]
			rows << ['image', res["vm_type"]]
			rows << ['type', res["type"]]
			if res["lab"]
				rows << ['lab', res["lab"]["name"]] 
			else
				rows << ['lab', '--- n/a ---'] 
			end

			ip_addr = res["descriptor"]["ip_addr"] ? res["descriptor"]["ip_addr"] : "-- n/a --"
			mac_addr = res["descriptor"]["mac_addr"] ? res["descriptor"]["mac_addr"] : "-- n/a --"

			rows << ['ip_addr', ip_addr]
			rows << ['mac_addr', mac_addr]

			table = Terminal::Table.new :headings => ['Key','Value'], :rows => rows
			puts table
		rescue => e
			abort e.to_s
		end


	end
end

