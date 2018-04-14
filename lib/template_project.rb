require_relative 'core/zero_file_utils'

module ZeroSolution

	class TemplateProject

		attr_reader :template_name, :template_version, :type, :copy_folders

		TEMPLATE_FILE = './template_project.yml'
		TEMPLATE_OF_TEMPLATE_FILE = File.dirname(__FILE__) + '/../templates/template_project.yml'

		def initialize(template_name=nil, template_version=nil)
			@template_name 		= template_name
			@template_version = template_version
			@type							= 'android_studio' # default template type
			@copy_folders			= Hash.new
		end

		def init
			logger = ZeroLogger.logger("main")
			logger.begin('init as a template project')
			logger.level += 1

			if !ZeroFileUtils.exists?(TEMPLATE_OF_TEMPLATE_FILE)
				logger.add_error("Cannot find the template of template project")
				return
			end

			logger.add_msg("template name:    #{@template_name}")
			logger.add_msg("template version: #{@template_version}")
			
			template_project_dash = load_default_template_project
			ZeroFileUtils.write(TEMPLATE_FILE, template_project_dash)
			fill_template_copy(template_project_dash)
			logger.add_msg("File created:     #{TEMPLATE_FILE}")
		end

		def load
			template_project_dash = ZeroFileUtils.load_yaml(TEMPLATE_FILE)
			@template_name 		= template_project_dash[:name]
			@template_version = template_project_dash[:version_string]
			@type							= template_project_dash[:type]

			fill_template_copy(template_project_dash)
		end

		def load_by_dir(dir)
			template_project_dash = ZeroFileUtils.load_yaml(dir + '/' + TEMPLATE_FILE)
			@template_name 		= template_project_dash[:name]
			@template_version = template_project_dash[:version_string]
			@type							= template_project_dash[:type]

			fill_template_copy(template_project_dash)
		end

		def publish
			logger = ZeroLogger.logger("main")

			template_center = TemplateCenter.load
			if template_center.nil?
				logger.add_error('No Template Center Defined.')
				return
			end

			logger.add_msg("`#{@template_name} - #{template_version}`")
			# copy current template project to template center
			src  = Dir.pwd
			dest = template_center.center_dir + "/#{@template_name}/#{template_version}"

			ZeroFileUtils.cp_directory(src, dest)

			logger.add_msg("published to template center #{template_center.center_dir}")
		end

		def self.is_template_project?
			ZeroFileUtils.exists?(TEMPLATE_FILE)
		end

		def self.load_template_project
			template_project = TemplateProject.new
			template_project.load
			return template_project
		end

		def self.load_template_project_by_dir(dir)
			if ZeroFileUtils.exists?(dir + '/' + TEMPLATE_FILE)
				template_project = TemplateProject.new
				template_project.load_by_dir(dir)
				return template_project
			else
				nil
			end
		end

		def self.publish
			logger = ZeroLogger.logger("main")
			logger.begin('Template Publish')
			if !is_template_project?
				logger.add_error('Current path is not a template project.')
				return
			end
			logger.level += 1
			template = TemplateProject.new
			template.load
			template.publish
		end

		private
		def load_default_template_project
			if ZeroFileUtils.exists?(TEMPLATE_FILE)
				dash =  ZeroFileUtils.load_yaml(TEMPLATE_FILE)
				fill_template_project_name_and_version(dash)
				return dash
			else
				return template_load_template
			end
		end

		def template_load_template
			template_dash = ZeroFileUtils.load_yaml(TEMPLATE_OF_TEMPLATE_FILE)
			fill_template_project_name_and_version(template_dash)
			template_dash[:template_center] = "path_to_template_center"

			template_dash
		end

		def fill_template_project_name_and_version(template_project_dash)
			template_project_dash[:name] = @template_name
			template_project_dash[:version_string] = @template_version
			template_project_dash[:version] = @template_version.split('.').map { |v| v.to_i }
		end

		def fill_template_copy(template_project_dash)
			@copy_folders = template_project_dash[:vocabulary][:copy]
		end

	end

end