module ZeroSolution

	class Installer

		def install
			@logger = ZeroLogger.logger("main")
			@logger.begin('install templates')
			template_use = TemplateUse.load
			if template_use.nil?
				@logger.add_error("Install cannot perform without templates.yml.")
				@logger.add_error("Using templatecli use `template_name` `version` first.")
				return
			end
			@logger.level += 1
			template_use.uses.each do |template|
				install_template(template)
			end
		end

		private
		def install_template(template)
			@logger.add_msg("Template `#{template.name} - #{template.version}`")
			
			# install the template
			template_center = TemplateCenter.load
			@logger.level += 1

			template_project = template_center.find_template(template)
			if !template_project.nil?
				@logger.add_msg("Found template #{template_project.inspect}.")
			else
				@logger.add_msg("Not found in template center.")
			end
			@logger.level -= 1

			@logger.add_msg("Installed.")
		end

	end

end