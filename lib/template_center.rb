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
				template_array = Array.new
				template_center_dash = template_load_template_center
				
				sub_files.each do |file_name|
					template_path = @center_dir + '/' + file_name

					if file_name != '.' && file_name != '..' && Dir.exists?(template_path)
						# should enter and get the version path
						version_files = ZeroFileUtils.list(template_path)
						
						version_files.each do |version|
							if version != '.' && version != '..'
								template_project = TemplateProject.load_template_project_by_dir(template_path + '/' + version)
							
								if !template_project.nil?
									# Add to center file
									logger.add_msg("Template `#{template_project.template_name} - #{template_project.template_version}`")
									template_array << { template_project.template_name => template_project.template_version }
									
								end
							end
						end
						
					end
				end
				template_center_dash[:templates] = template_array
				logger.level -= 1
				ZeroFileUtils.write(center_dir + '/' + TEMPLATE_CENTER_FILE, template_center_dash)
				logger.add_msg('Re indexes of templates.')
			end
		end

		def find_template(template)
			templates_ary_dash = load_center_templates_dash

			if templates_ary_dash.nil? || templates_ary_dash.empty?
				logger = ZeroLogger.logger("main")
				scan
				templates_ary_dash = load_center_templates_dash
			end

			if templates_ary_dash.nil? || templates_ary_dash.empty?
				return nil
			end

			by_version = template.version != VERSION_LATEST
			# find template by name
			found_templates_ary_dash = templates_ary_dash.select do |template_path_dash|
				template_name, template_version = load_template_dash(template_path_dash)

				if by_version
					template_name == template.name && template_version == template.version
				else
					template_name == template.name
				end
			end

			if by_version
				return nil if found_templates_ary_dash.nil? || found_templates_ary_dash.empty?
				template_name, template_version = load_template_dash(found_templates_ary_dash[0])
				return load_template(template_name, template_version)
			end

			# sort the template by version
			found_templates_ary_dash.sort! do |current_template, next_template|
				template_name, current_template_version = load_template_dash(current_template)
				template_name, next_template_version = load_template_dash(next_template)
				current_template_version_code = version_code(current_template_version)
				next_template_version_code = version_code(next_template_version)
				next_template_version_code <=> current_template_version_code
			end

			template_name, template_version = load_template_dash(found_templates_ary_dash[0])
			return load_template(template_name, template_version)
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

		def load_template_dash(template_path_dash)
			template_name = template_path_dash.keys[0]
			template_version = template_path_dash[template_name]
			return template_name, template_version
		end

		def version_code(template_version)
			# 1.0.1 => 1.01, 1.0.1.1  => 1.011
			first_dot_pos = template_version.index('.')
			version_code = template_version.gsub(/\./, '')
			version_code.insert(first_dot_pos, '.')
			version_code.to_f
		end

		def load_template(template_name, template_version)
			dir = @center_dir + '/' + template_name + '/' + template_version
			TemplateProject.load_template_project_by_dir(dir)
		end

		def load_center_templates_dash
			templates_center_dash = ZeroFileUtils.load_yaml(@center_dir + '/' + TEMPLATE_CENTER_FILE)
			templates_center_dash[:templates]
		end

	end

end