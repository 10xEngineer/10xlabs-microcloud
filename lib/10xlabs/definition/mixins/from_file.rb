module TenxLabs
 	module Mixin
		module FromFile
			def from_file(file_name)
				raise IOError, "File '#{file_name}' does not exist." unless File.exists? file_name

				self.instance_eval(IO.read(file_name), file_name, 1)
			end
		end
	end
end