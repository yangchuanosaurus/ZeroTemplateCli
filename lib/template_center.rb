require_relative 'core/zero_file_utils'

module ZeroSolution

	class TemplateCenter

		attr_reader :center_dir, :name, :version

		TEMPLATE_CENTER_FILE 				= '.template-center'
		TEMPLATE_CENTER_GLOBAL_FILE = '.template-center-global'
		TEMPLATE_OF_TEMPLATE_CENTER = File.dirname(__FILE__) + '/../templates/template_center.yml'

		TEMPLATE_CENTER_GLOBAL_FILE_PATH = "#{Dir.home}/#{TEMPLATE_CENTER_GLOBAL_FILE}"
		
		def init
			logger = ZeroLogger.logger("main")
			logger.begin('init as template center')
			logger.level += 1

			@center_dir = Dir.pwd
			@version = ZeroSolution.version

			logger.add_msg("Using path #{@center_dir}")
			if ZeroFileUtils.exists?(TEMPLATE_CENTER_FILE)
				logger.add_msg("#{@center_dir} is a template center already.")
			else
				# create TEMPLATE_CENTER_FILE with content
				template_center_dash = template_load_template_center
				ZeroFileUtils.write(TEMPLATE_CENTER_FILE, template_center_dash)

				# create global template center file with content in ~/.template-center-global
				ZeroFileUtils.write(TEMPLATE_CENTER_GLOBAL_FILE_PATH, template_center_dash)
				logger.add_msg("Initialized as a template center.")
			end
		end

		def load
			project_dash = ZeroFileUtils.load_yaml(TEMPLATE_CENTER_GLOBAL_FILE_PATH)
			@center_dir  = project_dash[:local]
			@name 			 = project_dash[:name]
			@version 		 = project_dash[:version]
		end

		def scan
			logger = ZeroLogger.logger("main")
			logger.add_msg("Scan #{center_dir}")

			# Scan center_dir
			sub_files = ZeroFileUtils.list(@center_dir)
			if !sub_files.nil? && sub_files.length > 0
				logger.level += 1

				template_center_dash = template_load_template_center
				template_array = Array.new
				sub_files.each do |file_name|
					if file_name != '.' && file_name != '..'
						template_project = TemplateProject.load_template_project_by_dir(@center_dir + '/' + file_name)
						
						if !template_project.nil?
							# Add to center file
							logger.add_msg("Template `#{template_project.template_name} - #{template_project.template_version}`")
							template_array << { file_name => { template_project.template_name => template_project.template_version } }
							
						end
					end
				end
				template_center_dash[:templates] = template_array
				logger.level -= 1
				puts TEMPLATE_CENTER_FILE
				ZeroFileUtils.write(center_dir + '/' + TEMPLATE_CENTER_FILE, template_center_dash)
				logger.add_msg('Re indexes of templates.')
			end
		end

		def find_template?(template)
			return true
		end

		def self.is_exists?
			ZeroFileUtils.exists?(TEMPLATE_CENTER_GLOBAL_FILE_PATH)
		end

		def self.load
			if is_exists?
				center = TemplateCenter.new()
				center.load
				return center
			else
				# Template center not defined
				return nil
			end
		end

		def self.scan
			logger = ZeroLogger.logger("main")
			logger.begin('templatecli center scan')
			logger.level += 1
			template_center = TemplateCenter.load
			if template_center.nil?
				logger.add_error("No template center defined.")
				return
			end

			template_center.scan
		end

		private
		def template_load_template_center
			template_center_dash = ZeroFileUtils.load_yaml(TEMPLATE_OF_TEMPLATE_CENTER)
			template_center_dash[:version] = ZeroSolution.version
			template_center_dash[:local] = Dir.pwd

			template_center_dash
		end

	end

end