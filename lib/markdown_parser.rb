class MarkdownParser

  def parse(filename)
    resources = []
    current_resource = nil
    if filename != nil
      File.open(filename).each do |line|
        if line.start_with?("##")
          resource_name = find_resource_name(line)
          if resource_name
            current_resource = resource_name
            if (! resources.include?(resource_name))
              resources << resource_name
            end
          end
        end
      end
    end
    return resources
  end

  def find_resource_name(string)
    resource_name = last_significative_uri_value(between_brackets(string))
    return resource_name
  end


  def between_brackets(string)
    result = nil
    if string != nil
      opening_bracket = Regexp.escape("[")
      closing_bracket = Regexp.escape("]")
      result = string[/#{opening_bracket}(.*?)#{closing_bracket}/m, 1]
    end
    return result
  end

  def last_significative_uri_value(string)
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
