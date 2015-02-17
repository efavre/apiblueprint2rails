require 'markdown_parser'

RSpec.describe MarkdownParser, "#parse" do
  context "no file" do
    it "should return empty resource array" do
      markdown_parser = MarkdownParser.new
      parsed_markdown = markdown_parser.parse(nil)
      expect(parsed_markdown).to eq([])
    end
  end

  context "file with one uri between brackets" do
    it "should return one resource mapped" do
      markdown_parser = MarkdownParser.new
      parsed_markdown = markdown_parser.parse("spec/test_files/one_uri.md")
      expect(parsed_markdown).to eq(["notes"])
    end
  end

  context "file with several uris between brackets" do
    it "should return three resource mapped" do
      markdown_parser = MarkdownParser.new
      parsed_markdown = markdown_parser.parse("spec/test_files/several_uri.md")
      expect(parsed_markdown).to eq(["notes","users","contacts"])
    end
  end

  context "file with one uri and one verb" do
    it "should return one resource mapped" do
      markdown_parser = MarkdownParser.new
      parsed_markdown = markdown_parser.parse("spec/test_files/several_uri.md")
      expect(parsed_markdown).to eq(["notes","users","contacts"])
    end
  end

end

RSpec.describe MarkdownParser, "#between_brackets" do

  context "nil string" do
    it "should return nil" do
      markdown_parser = MarkdownParser.new
      result_between_brackets = markdown_parser.between_brackets(nil)
      expect(result_between_brackets).to eq(nil)
    end
  end

  context "no brackets in string" do
    it "should return nil" do
      markdown_parser = MarkdownParser.new
      result_between_brackets = markdown_parser.between_brackets("no brackets here")
      expect(result_between_brackets).to eq(nil)
    end
  end

  context "only one bracket in string" do
    it "should return nil" do
      markdown_parser = MarkdownParser.new
      result_between_brackets = markdown_parser.between_brackets("only one bracket [ here")
      expect(result_between_brackets).to eq(nil)
    end
  end

  context "two brackets in string" do
    it "should return value between brackets" do
      markdown_parser = MarkdownParser.new
      result_between_brackets = markdown_parser.between_brackets("two brackets [here]")
      expect(result_between_brackets).to eq("here")
    end
  end
end

RSpec.describe MarkdownParser, "#find_resource_name" do

  context "nil string" do
    it "should return nil" do
      markdown_parser = MarkdownParser.new
      resource_name = markdown_parser.find_resource_name(nil)
      expect(resource_name).to eq(nil)
    end
  end

  context "one word uri" do
    it "should return word" do
      markdown_parser = MarkdownParser.new
      resource_name = markdown_parser.find_resource_name("[/that_resource]")
      expect(resource_name).to eq("that_resource")
    end
  end

  context "two words uri" do
    it "should return last word" do
      markdown_parser = MarkdownParser.new
      resource_name = markdown_parser.find_resource_name("[/that/resource]")
      expect(resource_name).to eq("resource")
    end
  end

  context "two words uri and trailing {id}" do
    it "should return last significative word" do
      markdown_parser = MarkdownParser.new
      resource_name = markdown_parser.find_resource_name("[/that/resource/{id}]")
      expect(resource_name).to eq("resource")
    end
  end

end


RSpec.describe MarkdownParser, "#last_significative_uri_value" do
  context "nil value" do
    it "should return nil" do
      markdown_parser = MarkdownParser.new
      last_significative_uri_value = markdown_parser.last_significative_uri_value(nil)
      expect(last_significative_uri_value).to eq(nil)
    end
  end
  
  context "no / in string" do
    it "should return whole string" do
      markdown_parser = MarkdownParser.new
      last_significative_uri_value = markdown_parser.last_significative_uri_value("noslashhere")
      expect(last_significative_uri_value).to eq("noslashhere")
    end
  end

  context "one / in string" do
    it "should return whole string" do
      markdown_parser = MarkdownParser.new
      last_significative_uri_value = markdown_parser.last_significative_uri_value("oneslash/here")
      expect(last_significative_uri_value).to eq("here")
    end
  end

  context "two / in string" do
    it "should return whole string" do
      markdown_parser = MarkdownParser.new
      last_significative_uri_value = markdown_parser.last_significative_uri_value("two/slashes/here")
      expect(last_significative_uri_value).to eq("here")
    end
  end

  context "trailing / in string" do
    it "should return whole string" do
      markdown_parser = MarkdownParser.new
      last_significative_uri_value = markdown_parser.last_significative_uri_value("/two/slashes/here/")
      expect(last_significative_uri_value).to eq("here")
    end
  end
end