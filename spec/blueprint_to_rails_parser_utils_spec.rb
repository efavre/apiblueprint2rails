require 'blueprint2rails/blueprint_to_rails_parser'

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

RSpec.describe BlueprintToRailsParser, "#get_render_format" do
  context "application/json" do
    it "should return json" do
      render_format = BlueprintToRailsParser.get_render_format("Application/json")
      expect(render_format).to eq("json")
    end
  end
  
  context "APPLICATION/JSON" do
    it "should return show" do
      render_format = BlueprintToRailsParser.get_render_format("APPLICATION/JSON")
      expect(render_format).to eq("json")
    end
  end

  context "text/xml" do
    it "should return create" do
      render_format = BlueprintToRailsParser.get_render_format("text/xml")
      expect(render_format).to eq("xml")
    end
  end

  context "TEXT/XML" do
    it "should return nil" do
      render_format = BlueprintToRailsParser.get_render_format("TEXT/XML")
      expect(render_format).to eq("xml")
    end
  end

  context "application/xml" do
    it "should return nil" do
      render_format = BlueprintToRailsParser.get_render_format("application/xml")
      expect(render_format).to eq("xml")
    end
  end

  context "APPLICATION/XML" do
    it "should return update" do
      render_format = BlueprintToRailsParser.get_render_format("APPLICATION/XML")
      expect(render_format).to eq("xml")
    end
  end

end