require 'blueprint2rails/blueprint_to_rails_parser'

class Blueprint2railsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def parse_apiblueprint_file
    @api_resources = BlueprintToRailsParser.parse(file_path)
  end
 
  def create_rails_resources
    @api_resources.each do |api_resource|
      p "Creating resource #{api_resource[0]}"
      api_resource[1][:actions].each do |rails_action|
        @resource_name = rails_action
        api_resource[1][:render_format].each do |render_format|
          template "views/#{view_language}/#{action}.html.#{view_language}", "app/views/#{plural_name}/#{action}.html.#{view_language}"
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

end
