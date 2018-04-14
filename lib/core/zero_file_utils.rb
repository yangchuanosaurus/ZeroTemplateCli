require 'yaml'
require 'fileutils'

module ZeroSolution
	class ZeroFileUtils

		def self.exists?(file_name)
			File.exists?(file_name)
		end

		def self.load_yaml(relative_file_path)
			YAML.load_file(relative_file_path)
		end

		def self.write(file, dash)
			mode = "w"
			File.open(file, mode) do |file|
				file.puts dash.to_yaml
			end
		end

		def self.cp_directory(src, dest)
			# copy all files in src to dest
			FileUtils.mkdir_p(File.dirname(dest)) if !exists?(dest)
			FileUtils.cp_r(src + '/.', dest)
		end

		def self.list(dir_name)
			Dir.entries(dir_name)
		end

	end
end