require_relative 'migration_copy'

module ZeroSolution

	class MigrationJavaMavenCopy < MigrationCopy

		def migrate(src_dash, dest_dash)
			puts "migrate java maven copy src={#{src_dash}} to dest={#{dest_dash}}"
		end

	end
	
end