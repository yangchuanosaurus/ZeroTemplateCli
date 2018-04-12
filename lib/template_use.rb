require_relative 'core/zero_file_utils'

module ZeroSolution

	class TemplateUse

		attr_reader :uses

		TEMPLATE_FILE = './templates.yml'
		TEMPLATE_OF_TEMPLATE_FILE = File.dirname(__FILE__) + '/../templates/template_use.yml'

		def initialize
			@uses = Array.new
		end

		def use(template_name, template_version)
			template = Template.new(template_name, template_version)

			logger = ZeroLogger.logger("main")
			logger.begin("use template")
			logger.level += 1

			add_template(template)
			logger.add_msg("`#{template.name} : #{template.version}` added.")
			logger.add_msg("#{TEMPLATE_FILE} created.")
		end

		def publish
			logger = ZeroLogger.logger("main")
			logger.begin("publish `#{@template_name} : #{@template_version}` to center")
			logger.level += 1
			logger.add_msg("publish template")
		end

		def exists?
			ZeroFileUtils.exists?(TEMPLATE_FILE)
		end

		def self.load
			if ZeroFileUtils.exists?(TEMPLATE_FILE)
				template_use = TemplateUse.new
				template_use.load
				return template_use
			else
				return nil
			end
		end

		def load
			if exists?
				template_dash = ZeroFileUtils.load_yaml(TEMPLATE_FILE)
				template_uses( template_dash[:uses] )
			end
		end

		private
		def add_template(template)
			# create templates.yml with content from templates/template_use.yml
			uses_dash = Hash.new
			if exists?
				# append the template
				uses_dash = ZeroFileUtils.load_yaml(TEMPLATE_FILE)
				uses_array = uses_dash[:uses]
				if uses_array.nil?
					uses_dash[:uses] = [{template.name => template.version}]
				else
					uses_array.delete_if { |use| use.keys[0] == template.name }
					uses_array << {template.name => template.version}
				end
			else
				# init with the template
				uses_dash = ZeroFileUtils.load_yaml(TEMPLATE_OF_TEMPLATE_FILE)
				uses_dash[:uses] = [{template.name => template.version}]
			end

			ZeroFileUtils.write(TEMPLATE_FILE, uses_dash)

			template_uses( uses_dash[:uses] )
		end

		def template_uses(uses_dash)
			if !uses_dash.nil?
				uses_dash.map do |template_dash|
					template_name = template_dash.keys[0]
					template_version = template_dash[template_name]
					@uses << Template.new(template_name, template_version)
				end
			end
		end
	end

	class Template
		attr_reader :name, :version

		def initialize(template_name, template_version)
			@name 	 = template_name
			@version = template_version
		end

	end

end