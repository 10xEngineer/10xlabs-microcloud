require 'logger'
require 'terminal-table'
require '10xlabs/microcloud'

log = Logger.new(STDOUT)
log.level = Logger::WARN

#
# Release Lab Definition
#
command :versions do |c|
	c.description = "Display lab definition versions"

	c.action do |args, options|
		TenxLabs::CLI.populate_defaults(options)

		# FIXME validate lab name
		lab_name = args.shift

		begin
			lab_res = TenxLabs::CLI.microcloud.get_ext "/labs/#{lab_name}"
			labdef_versions = TenxLabs::CLI.microcloud.get_ext "/labs/#{lab_name}/versions"

			versions = []
			labdef_versions.each do |version|
				deployed = false
				deployed = true if lab_res["current_definition"] && lab_res["current_definition"]["version"] == version["version"]

				active = ( deployed ? "TRUE": "" )

				versions << [version["version"], version["revision"], active, version["meta"]["created_at"]]
			end

			table = Terminal::Table.new :headings => ['version','revision', 'active', 'created_at'], :rows => versions
			puts table
		rescue => e
			abort e.to_s
		end
	end
end