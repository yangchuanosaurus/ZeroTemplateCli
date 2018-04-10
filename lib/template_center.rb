require_relative 'core/fileutils'

module ZeroSolution

	class TemplateCenter

		TEMPLATE_CENTER_FILE 				= '.template-center'
		TEMPLATE_CENTER_GLOBAL_FILE = '.template-center-global'
		TEMPLATE_OF_TEMPLATE_CENTER = '/templates/template_center.yml'
		
		def init
			logger = ZeroLogger.logger("main")
			logger.begin('init as template center')
			logger.level += 1

			center_dir = Dir.pwd
			logger.add_msg("Using path #{center_dir}")
			if FileUtils.exists?(TEMPLATE_CENTER_FILE)
				logger.add_msg("#{center_dir} is a template center already.")
			else
				# create TEMPLATE_CENTER_FILE with content
				template_center_dash = template_load_template_center
				FileUtils.write(TEMPLATE_CENTER_FILE, template_center_dash)

				# create global template center file with content in ~/.template-center-global
				global_template_center = "#{Dir.home}/#{TEMPLATE_CENTER_GLOBAL_FILE}"
				FileUtils.write(global_template_center, template_center_dash)
				logger.add_msg("Initialized as a template center.")
			end
		end

		private
		def template_load_template_center
			template_center_dash = FileUtils.load_yaml(TEMPLATE_OF_TEMPLATE_CENTER)
			template_center_dash[:version] = ZeroSolution.version
			template_center_dash[:local] = Dir.pwd

			template_center_dash
		end

	end

end