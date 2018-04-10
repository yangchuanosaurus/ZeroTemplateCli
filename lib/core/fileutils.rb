require 'yaml'

module ZeroSolution
	class FileUtils

		def self.exists?(file_name)
			File.exists?(file_name)
		end

		def self.load_yaml(relative_file_path)
			YAML.load_file(full_path(relative_file_path))
		end

		def self.write(file, dash)
			puts "file  #{file}"
			mode = "w"
			File.open(file, mode) do |file|
				file.puts dash.to_yaml
			end
		end

		def self.full_path(path)
			"#{self.root_path}/#{path}"
		end

		def self.root_path
			Dir.pwd
		end

	end
end