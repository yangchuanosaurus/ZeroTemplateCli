require_relative 'template_project'
require_relative 'template_center'
require_relative 'template'
require_relative 'template_install'
require_relative 'version'

module ZeroSolution

	class Command

		def self.init(*params)
			logger = ZeroLogger.logger("main")

			if params.empty? || params.size < 2
				logger.begin('templatecli init')
				logger.add_error("wrong arguments of `init`.")
				return
			end

			template_name 		= params[0]
			template_version  = params[1]

			if template_name.downcase == 'as'
				if template_version.downcase == 'center'
					center = TemplateCenter.new
					center.init
					return
				else
					logger.begin('templatecli init as what?')
					logger.add_error("arguments of `init` should be `as center`.")
					return
				end
			end

			project = TemplateProject.new(template_name, template_version)
			project.init

		end

		def self.use(*params)
			logger = ZeroLogger.logger("main")

			if params.empty?
				logger.begin("templatecli use template_name version[optional]")
				logger.add_error("wrong arguments of `use`.")
				return
			end

			# check if the template exists in template center

			template_name 	 = params[0]
			template_version = params.size == 2 ? params[1] : 'latest'

			template = Template.new(template_name, template_version)
			template.use
		end

		def self.publish
			logger = ZeroLogger.logger("main")

			# check if current path is a template project

			template_name 	 = 'fetch from config'
			template_version = 'fetch from config'
			template = Template.new(template_name, template_version)
			template.publish
		end

		def self.info
			logger = ZeroLogger.logger("main")
			logger.begin("TemplateCli of Zero-Solution")
			logger.level += 1
			logger.add_msg("version: #{ZeroSolution.version}")
			logger.add_msg("update:  #{ZeroSolution.date}")
		end

		def self.install
			logger = ZeroLogger.logger("main")

			# check if current path is a template consumer project
			# check if dependency templates exists in template center
			# check if vocabulary exists
			installer = Installer.new
			installer.install
		end

	end

end