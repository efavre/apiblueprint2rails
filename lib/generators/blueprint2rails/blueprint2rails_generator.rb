require 'rails/generators'
require 'blueprint2rails/blueprint2rails_parser'

class Blueprint2railsGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def parse_apiblueprint_file
    @api_resources = Blueprint2railsParser.parse(file_path)
  end
 
  def create_rails_renderers_template
    @api_resources.each do |api_resource|
      @resource_name = api_resource[0]
      api_resource[1][:actions].each do |rails_action|
        api_resource[1][:render_formats].each do |render_format|
          template "views/#{render_format}/#{rails_action}.#{render_format}.jbuilder", "app/views/#{plural_name}/#{rails_action}.#{render_format}.jbuilder"
        end
      end
    end
  end

  def create_rails_controllers
    @api_resources.each do |api_resource|
      @resource_name = api_resource[0]
      template "controllers/controller.rb", "app/controllers/#{plural_name}_controller.rb"
    end
  end

private 

  def singular_name
    @resource_name.underscore.singularize
  end

  def plural_name
    @resource_name.underscore.pluralize
  end

  def plural_class_name
    plural_name.camelize
  end

  def singular_class_name
    singuar_name.camelize
  end

  def controller_methods
    actions = @api_resources[@resource_name][:actions]
    actions.each do |action|
      read_template("controllers/#{action}.rb")
      end.join("\n").strip
  end

  def read_template(relative_path)
    template_file = File.expand_path('../templates', __FILE__) + "/" + relative_path
    result = ERB.new(File.read(template_file), nil, '-').result(binding)
    p result
    return result
  end


end
