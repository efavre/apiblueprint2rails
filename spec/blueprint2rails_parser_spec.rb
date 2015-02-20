require 'blueprint2rails/blueprint2rails_parser'

RSpec.describe Blueprint2railsParser, "#parse" do
  
  context "no file" do
    it "should return empty resource array" do
      resources = Blueprint2railsParser.parse(nil)
      expect(resources).to eq({})
    end
  end
  
  context "file one_uri" do
    it "should return one resource mapped" do
      resources = Blueprint2railsParser.parse("spec/test_files/one_uri.md")
      expect(resources).to eq({"notes"=> {actions:[],:render_formats=>[]}})
    end
  end

  context "file several_uri" do
    it "should return three resource mapped" do
      resources = Blueprint2railsParser.parse("spec/test_files/several_uri.md")
      expect(resources).to eq({"notes"=>{actions:[],:render_formats=>[]},"users"=>{actions:[],:render_formats=>[]},"contacts"=>{actions:[],:render_formats=>[]}})
    end
  end

  context "file one_collection_uri_one_verb" do
    it "should return one collection resource with one verb" do
      resources = Blueprint2railsParser.parse("spec/test_files/one_collection_uri_one_verb.md")
      expect(resources).to eq({"notes" => {actions:["index"],:render_formats=>[]}})
    end
  end

  context "file one_member_uri_one_verb" do
    it "should return one member resource with one verb" do
      resources = Blueprint2railsParser.parse("spec/test_files/one_member_uri_one_verb.md")
      expect(resources).to eq({"notes" => {actions:["show"],:render_formats=>[]}})
    end
  end

  context "file one_uri_collection_and_member_several_verb" do
    it "should return one resource with several verbs" do
      resources = Blueprint2railsParser.parse("spec/test_files/one_uri_collection_and_member_several_verb.md")
      expect(resources).to eq({"notes" => {actions:["index","create","show","delete"],render_formats:[]}})
    end
  end

  context "file contacts" do
    it "should return one resource with several methods and is_collection" do
      resources = Blueprint2railsParser.parse("spec/test_files/contacts.md")
      expect(resources).to eq({"notes" => {actions:["index","create","show","delete"], render_formats:["json"]}})
    end
  end

end
