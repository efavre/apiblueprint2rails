require 'redsnow'

class MarkdownParser

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
          resources[rails_resource_name] = [] unless resources.include?(rails_resource_name)
          resource.actions.each do |action|
            render_formats = []
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
            resources[rails_resource_name] << {method:action.method,is_collection:@@is_collection,render_formats:render_formats}
          end
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
