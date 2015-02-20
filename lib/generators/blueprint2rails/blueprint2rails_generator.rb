require 'rails/generators'
require 'blueprint2rails/blueprint2rails_parser'

class Blueprint2railsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def parse_apiblueprint_file
    @api_resources = Blueprint2railsParser.parse(file_path)
  end
 
  def create_rails_resources
    @api_resources.each do |api_resource|
      @resource_name = api_resource[0]
      api_resource[1][:actions].each do |rails_action|
        api_resource[1][:render_formats].each do |render_format|
          template "views/#{render_format}/#{rails_action}.#{render_format}.jbuilder", "app/views/#{plural_name}/#{rails_action}.#{render_format}.jbuilder"
        end
      end
    end
  end

private 

  def singular_name
    @resource_name.underscore.singularize
  end

  def plural_name
    @resource_name.underscore.pluralize
  end

  def controller_methods(dir_name)
    controller_actions.map do |action|
      read_template("#{dir_name}/#{action}.rb")
      end.join("\n").strip
  end

end
