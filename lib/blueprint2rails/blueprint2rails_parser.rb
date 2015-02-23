require 'redsnow'

class Blueprint2railsParser

  def self.parse(filename)

    resources = {}
    if filename != nil

      apiblueprint_file = File.open(filename, "r")
      apiblueprint_string = apiblueprint_file.read
      result = RedSnow::parse(apiblueprint_string)
      
      result.ast.resource_groups.each do |resource_group| 
        resource_group.resources.each do |resource|
          @@is_collection = true
          rails_resource_name = last_significative_uri_value(resource.uri_template)

          unless resources.include?(rails_resource_name)
            test = {actions:[],render_formats:[]}
            resources[rails_resource_name] = test  
          end

          render_formats = []
          rails_actions = []
          resource.actions.each do |action|
            action.examples.each do |example|
              example.responses.each do |response|
                if response.headers
                  response.headers.collection.each do |header|
                    if header[:name] == "Content-Type"
                      render_formats << get_render_format(header[:value])
                    end
                  end
                end
              end
            end
            rails_actions << get_rails_action_name(action.method, @@is_collection)
          end
          rails_actions = resources[rails_resource_name][:actions] | rails_actions
          render_formats = render_formats | resources[rails_resource_name][:render_formats] 
          resources[rails_resource_name] = {actions:rails_actions,render_formats:render_formats}
        end
      end

    end

    return resources
  end

# TRANSLATE_TO_RAILS_FRIENDLY 

  def self.get_rails_action_name(method, is_collection)
    rails_action = nil
    case method
    when "GET"
      if is_collection
        rails_action = "index"
      else
        rails_action = "show"
      end
    when "POST"
      if is_collection
        rails_action = "create"
      end
    when "PUT"
      if ! is_collection
        rails_action = "update"
      end
    when "PATCH"
      if ! is_collection
        rails_action = "update"
      end
    when "DELETE"
      if ! is_collection
        rails_action = "destroy"
      end
    else 
      is_collection_message = is_collection ? "/resource" : "/resource/{param}"
      p "WARNING : no rails route found for #{method} on #{is_collection_message}"
    end
    return rails_action
  end

  def self.get_render_format(content_type)
    format = content_type.split("/")[1]
    render_format = nil
    case format.downcase
    when "json"
      render_format = "json"
    when "xml"
      render_format = "xml"
    end
    return render_format
  end

  def self.last_significative_uri_value(string)
    result = nil
    if string != nil
      @@is_collection = true
      uri_values = string.split("/")
      while uri_values.last.start_with?("{")
        @@is_collection = false
        uri_values.delete(uri_values.last)
      end
      if uri_values.any?
        result = uri_values.last
      end
    end
    return result
  end

end
