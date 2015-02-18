require('rails_resource')

class MarkdownParser

  def self.parse(filename)
    current_resource = nil
    resources = {}
    if filename != nil
      File.open(filename).each do |line|
        if line.start_with?("###")
          http_verb = find_http_verb(line)
          if http_verb
            resources[current_resource] << {http_verb: http_verb}
          end
        elsif line.start_with?("##")
          current_resource = find_resource_name(line)
          if ! resources.include?(current_resource)
            resources[current_resource] = []
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
      uri_values = string.split("/")
      while uri_values.last.start_with?("{")
        uri_values.delete(uri_values.last)
      end
      if uri_values.any?
        result = uri_values.last
      end
    end
    return result
  end

end
