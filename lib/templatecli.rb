require_relative 'template_project'
require_relative 'template_center'
require_relative 'template_use'
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

			template_use = TemplateUse.new
			template_use.use(template_name, template_version)
		end

		def self.publish
			logger = ZeroLogger.logger("main")

			# check if current path is a template project
			TemplateProject.publish
		end

		def self.info
			logger = ZeroLogger.logger("main")
			logger.begin("TemplateCli of Zero-Solution")
			logger.level += 1
			logger.add_msg("version: #{ZeroSolution.version}")
			logger.add_msg("update:  #{ZeroSolution.date}")

			if TemplateCenter.is_exists?
				template_center = TemplateCenter.load
				if !template_center.nil?
					logger.add_msg("Template Center")
					logger.level += 1
					logger.add_msg("path: #{template_center.center_dir}")
					logger.level -= 1
				end
			else
				logger.add_msg("Warning: No Template Center defined.")
			end
			
			# check if current folder is root of template project
			if TemplateProject.is_template_project?
				template_project = TemplateProject.load_template_project
				logger.add_msg("Template Project")
				logger.level += 1
				logger.add_msg("   name: #{template_project.template_name}")
				logger.add_msg("version: #{template_project.template_version}")
				logger.level -= 1
			end
			logger.add_msg("end.")
		end

		def self.install
			logger = ZeroLogger.logger("main")

			# check if current path is a template consumer project
			# check if dependency templates exists in template center
			# check if vocabulary exists
			installer = Installer.new
			installer.install
		end

		def self.center(*params)
			logger = ZeroLogger.logger("main")

			if params.empty? || params.size < 1
				logger.begin('templatecli center')
				logger.add_error("wrong arguments of `center`.")
				return
			end

			center_action  = params[0]

			if center_action.downcase == 'scan'
				TemplateCenter.scan
			elsif center_action.downcase == 'init'
				center = TemplateCenter.new
				center.init
			else
				logger.begin('templatecli center what?')
				logger.add_error("arguments of `center` is invalid.")
			end
		end

	end

end