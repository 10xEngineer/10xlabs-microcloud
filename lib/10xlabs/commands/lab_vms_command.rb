require 'logger'
require 'terminal-table'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

#
# Get Lab's VMs
#
command :vms do |c|
	c.description = "List VMs allocated to the specified lab"
	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# FIXME validate lab name
		lab_name = args.shift

		begin
			res = TenxLabs::CLI.microcloud.get_ext "/labs/#{lab_name}/vms"

			vms = []
			res.each do |vm|
				meta_vm = [vm["uuid"], vm["vm_name"], vm["state"]]

				vms << meta_vm
			end
			
			table = Terminal::Table.new :headings => ['UUD','name', 'state'], :rows => vms
			puts table
		rescue => e
			abort e.to_s
		end




	end
end