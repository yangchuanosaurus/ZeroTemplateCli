module ZeroSolution

	class MigrationCopy

		def migrate(src_dash, dest_dash)

			src_dash.each do |copy_name, copy_src_ary|
				copy_src_ary.each do |src|
					found_dest = dest_dash[copy_name]
					if !found_dest.nil?
						found_dest = "./#{found_dest}"
						# copy all files in src to dest
						FileUtils.mkdir_p(File.dirname(found_dest)) if !File.exists?(found_dest)
						FileUtils.cp_r(src + '/.', found_dest)
					end
				end
			end
			
		end

	end

end