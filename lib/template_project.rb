require_relative 'core/fileutils'

module ZeroSolution

	class TemplateProject

		TEMPLATE_FILE = './template.yml'
		TEMPLATE_OF_TEMPLATE_FILE = '/templates/template.yml'

		def initialize(template_name, template_version)
			@template_name 		= template_name
			@template_version = template_version
		end

		def init
			logger = ZeroLogger.logger("main")
			logger.begin('init as a template project')
			logger.level += 1
			if FileUtils.exists?(TEMPLATE_FILE)
			else
			end

			logger.add_msg("template name:    #{@template_name}")
			logger.add_msg("template version: #{@template_version}")
		end

		private
		def template_load_template
			template_dash = FileUtils.load_yaml(TEMPLATE_OF_TEMPLATE_FILE)
			template_dash[:version] = ZeroSolution.version
			template_dash[:local] = Dir.pwd

			template_dash
		end

	end

end