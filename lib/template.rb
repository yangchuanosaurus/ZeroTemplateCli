module ZeroSolution

	class Template

		def initialize(template_name, template_version)
			@template_name 		= template_name
			@template_version = template_version
		end

		def use
			logger = ZeroLogger.logger("main")
			logger.begin("use template `#{@template_name} : #{@template_version}`")
			logger.level += 1
			logger.add_msg("use template")
		end

		def publish
			logger = ZeroLogger.logger("main")
			logger.begin("publish `#{@template_name} : #{@template_version}` to center")
			logger.level += 1
			logger.add_msg("publish template")
		end

	end

end