require 'blueprint2rails/blueprint_to_rails_parser'

RSpec.describe BlueprintToRailsParser, "#parse" do
  
  context "no file" do
    it "should return empty resource array" do
      resources = BlueprintToRailsParser.parse(nil)
      expect(resources).to eq({})
    end
  end
  
  context "file one_uri" do
    it "should return one resource mapped" do
      resources = BlueprintToRailsParser.parse("spec/test_files/one_uri.md")
      expect(resources).to eq({"notes"=> {actions:[],:render_formats=>[]}})
    end
  end

  context "file several_uri" do
    it "should return three resource mapped" do
      resources = BlueprintToRailsParser.parse("spec/test_files/several_uri.md")
      expect(resources).to eq({"notes"=>{actions:[],:render_formats=>[]},"users"=>{actions:[],:render_formats=>[]},"contacts"=>{actions:[],:render_formats=>[]}})
    end
  end

  context "file one_collection_uri_one_verb" do
    it "should return one collection resource with one verb" do
      resources = BlueprintToRailsParser.parse("spec/test_files/one_collection_uri_one_verb.md")
      expect(resources).to eq({"notes" => {actions:["index"],:render_formats=>[]}})
    end
  end

  context "file one_member_uri_one_verb" do
    it "should return one member resource with one verb" do
      resources = BlueprintToRailsParser.parse("spec/test_files/one_member_uri_one_verb.md")
      expect(resources).to eq({"notes" => {actions:["show"],:render_formats=>[]}})
    end
  end

  context "file one_uri_collection_and_member_several_verb" do
    it "should return one resource with several verbs" do
      resources = BlueprintToRailsParser.parse("spec/test_files/one_uri_collection_and_member_several_verb.md")
      expect(resources).to eq({"notes" => {actions:["index","create","show","delete"],render_formats:[]}})
    end
  end

  context "file contacts" do
    it "should return one resource with several methods and is_collection" do
      resources = BlueprintToRailsParser.parse("spec/test_files/contacts.md")
      expect(resources).to eq({"notes" => {actions:["index","create","show","delete"], render_formats:["application/json"]}})
    end
  end

end

RSpec.describe BlueprintToRailsParser, "#between_brackets" do

  context "nil string" do
    it "should return nil" do
      result_between_brackets = BlueprintToRailsParser.between_brackets(nil)
      expect(result_between_brackets).to eq(nil)
    end
  end

  context "no brackets in string" do
    it "should return nil" do
      result_between_brackets = BlueprintToRailsParser.between_brackets("no brackets here")
      expect(result_between_brackets).to eq(nil)
    end
  end

  context "only one bracket in string" do
    it "should return nil" do
      result_between_brackets = BlueprintToRailsParser.between_brackets("only one bracket [ here")
      expect(result_between_brackets).to eq(nil)
    end
  end

  context "two brackets in string" do
    it "should return value between brackets" do
      result_between_brackets = BlueprintToRailsParser.between_brackets("two brackets [here]")
      expect(result_between_brackets).to eq("here")
    end
  end

end

RSpec.describe BlueprintToRailsParser, "#find_resource_name" do

  context "nil string" do
    it "should return nil" do
      resource_name = BlueprintToRailsParser.find_resource_name(nil)
      expect(resource_name).to eq(nil)
    end
  end

  context "one word uri" do
    it "should return word" do
      resource_name = BlueprintToRailsParser.find_resource_name("[/that_resource]")
      expect(resource_name).to eq("that_resource")
    end
  end

  context "two words uri" do
    it "should return last word" do
      resource_name = BlueprintToRailsParser.find_resource_name("[/that/resource]")
      expect(resource_name).to eq("resource")
    end
  end

  context "two words uri and trailing {id}" do
    it "should return last significative word" do
      resource_name = BlueprintToRailsParser.find_resource_name("[/that/resource/{id}]")
      expect(resource_name).to eq("resource")
    end
  end

end

RSpec.describe BlueprintToRailsParser, "#get_rails_action_name" do
  context "GET and is_collection" do
    it "should return index" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("GET", true)
      expect(rails_action).to eq("index")
    end
  end
  
  context "GET and not is_collection" do
    it "should return show" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("GET", false)
      expect(rails_action).to eq("show")
    end
  end

  context "POST and is_collection" do
    it "should return create" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("POST", true)
      expect(rails_action).to eq("create")
    end
  end

  context "POST and not is_collection" do
    it "should return nil" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("POST", false)
      expect(rails_action).to eq(nil)
    end
  end

  context "PUT and is_collection" do
    it "should return nil" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("PUT", true)
      expect(rails_action).to eq(nil)
    end
  end

  context "PUT and not is_collection" do
    it "should return update" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("PUT", false)
      expect(rails_action).to eq("update")
    end
  end

  context "DELETE and is_collection" do
    it "should return nil" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("DELETE", true)
      expect(rails_action).to eq(nil)
    end
  end

  context "DELETE and not is_collection" do
    it "should return delete" do
      rails_action = BlueprintToRailsParser.get_rails_action_name("DELETE", false)
      expect(rails_action).to eq("delete")
    end
  end
end

RSpec.describe BlueprintToRailsParser, "#last_significative_uri_value" do
  context "nil value" do
    it "should return nil" do
      last_significative_uri_value = BlueprintToRailsParser.last_significative_uri_value(nil)
      expect(last_significative_uri_value).to eq(nil)
    end
  end
  
  context "no / in string" do
    it "should return whole string" do
      last_significative_uri_value = BlueprintToRailsParser.last_significative_uri_value("noslashhere")
      expect(last_significative_uri_value).to eq("noslashhere")
    end
  end

  context "one / in string" do
    it "should return whole string" do
      last_significative_uri_value = BlueprintToRailsParser.last_significative_uri_value("oneslash/here")
      expect(last_significative_uri_value).to eq("here")
    end
  end

  context "two / in string" do
    it "should return whole string" do
      last_significative_uri_value = BlueprintToRailsParser.last_significative_uri_value("two/slashes/here")
      expect(last_significative_uri_value).to eq("here")
    end
  end

  context "trailing / in string" do
    it "should return whole string" do
      last_significative_uri_value = BlueprintToRailsParser.last_significative_uri_value("/two/slashes/here/")
      expect(last_significative_uri_value).to eq("here")
    end
  end
end