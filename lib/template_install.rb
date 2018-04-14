require_relative 'vocabulary_libs'
require_relative 'version'

module ZeroSolution

	class Installer

		def install
			@logger = ZeroLogger.logger("main")
			@logger.begin('install templates')
			@template_use = TemplateUse.load
			if @template_use.nil?
				@logger.add_error("Install cannot perform without templates.yml.")
				@logger.add_error("Using templatecli use `template_name` `version` first.")
				return
			end
			@logger.level += 1

			@template_center = TemplateCenter.load

			@template_use.uses.each do |template|
				template_project = @template_center.find_template(template)
				install_template(template_project)
			end
		end

		private
		def install_template(template_project)
			# check if current is a template use project
			@logger.add_msg("Template `#{template_project.template_name} - #{template_project.template_version}`")
			
			# install the template
			
			@logger.level += 1

			if !template_project.nil?
				@logger.add_msg("Migration Copy")

				dest_dash = @template_use.dest_folders

				src_dash = template_project.copy_folders
				src_dash.each do |section, src_ary|
					@logger.level += 1
					n_src_ary = src_ary.collect do |src|
						full_src = "#{@template_center.center_dir}/#{template_project.template_name}/#{template_project.template_version}/#{src}"
						@logger.add_msg("#{section} '#{full_src}'' to '#{dest_dash[section]}'")
						full_src
					end
					src_dash[section] = n_src_ary
					@logger.level -= 1
				end

				type = template_project.type
				migration_copy = instance_of_class( type_class(type) )
				migration_copy.migrate(src_dash, dest_dash)
			else
				@logger.add_msg("Not found in template center.")
			end
			@logger.level -= 1

			@logger.add_msg("Installed.")
		end

		def instance_of_class(class_str)
			clazz = class_str.split('::').inject(Object) { |o, c| o.const_get c }
		  return clazz.new
		end

		def type_class(template_type)
			template_type_words = template_type.split('_').collect { |x| x[0].upcase + x[1..-1].downcase}
			template_type_str = template_type_words.join('')
			"ZeroSolution::Migration#{template_type_str}Copy"
		end

	end

end