require 'rails/generators'
require 'blueprint2rails/blueprint2rails_parser'

class Blueprint2railsGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def parse_apiblueprint_file
    @api_resources = Blueprint2railsParser.parse(file_path)
  end
  
  def create_rails_models
    @api_resources.each do |api_resource|
      @resource_name = api_resource[0]
      template "models/model.rb", "app/models/#{singular_name}.rb"
    end
  end

  def create_rails_renderers_templates
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

  def create_rails_routes
    @api_resources.each do |api_resource|
      @resource_name = api_resource[0]
      actions_array = @api_resources[@resource_name][:actions].map{|action| action.to_sym}
      inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do
        "  resources :#{@resource_name}, only: #{actions_array}"
      end
    end
  end

protected 

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
    singular_name.camelize
  end

  def controller_methods
    actions = @api_resources[@resource_name][:actions]
    controller_content = "\n"
    actions.each do |action|
      controller_content += read_template("controllers/#{action}.rb") + "\n\n"
    end
    return controller_content
  end

  def read_template(relative_path)
    template_file = File.expand_path('../templates', __FILE__) + "/" + relative_path
    result = ERB.new(File.read(template_file), nil, '-').result(binding)
    return result
  end

end
