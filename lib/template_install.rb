module ZeroSolution

	class Installer

		def install
			logger = ZeroLogger.logger("main")
			logger.begin('install templates')
			logger.level += 1
			logger.add_msg("install templates in progress")
		end

	end

end