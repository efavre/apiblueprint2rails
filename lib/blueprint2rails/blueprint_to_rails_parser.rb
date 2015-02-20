require 'redsnow'

class BlueprintToRailsParser

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
                      render_formats << header[:value]
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

# RAILS_RESOURCE 

  def self.find_resource_name(string)
    resource_name = last_significative_uri_value(between_brackets(string))
    return resource_name
  end

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
    when "DELETE"
      if ! is_collection
        rails_action = "delete"
      end
    end
    return rails_action
  end

# API_SERVICE

  def self.find_http_verb(string)
    http_verb = between_brackets(string)
    return http_verb
  end

# UTILS

  def self.between_brackets(string)
    result = nil
    if string != nil
      opening_bracket = Regexp.escape("[")
      closing_bracket = Regexp.escape("]")
      result = string[/#{opening_bracket}(.*?)#{closing_bracket}/m, 1]
    end
    return result
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
