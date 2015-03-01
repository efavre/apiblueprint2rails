require 'generator_spec'
require 'generators/blueprint2rails/blueprint2rails_generator'

describe Blueprint2railsGenerator, type: :generator do

  TEMP_DIR = File.expand_path("../../tmp", __FILE__)
  destination TEMP_DIR
  arguments %w(spec/test_files/contacts.md)

  before(:all) do
    prepare_destination
    Dir.mkdir("#{TEMP_DIR}/config") unless File.exists?("#{TEMP_DIR}/config")
    File.open("#{TEMP_DIR}/config/routes.rb", 'w') do |f|
      f.puts "Rails.application.routes.draw do\n\nend"
    end
    run_generator
  end

  context "Blueprint2railsGenerator #read_template" do

    before(:each) do
      Blueprint2railsGenerator.send(:public, *Blueprint2railsGenerator.protected_instance_methods)
    end

    it "should return create action template" do
      blueprint2railsGenerator = generator
      blueprint2railsGenerator.instance_variable_set(:@resource_name, "notes")
      template = generator.read_template("controllers/create.rb")
      expect(template).to include("def create")
      expect(template).to include("@note =")
    end

    it "should return destroy action template" do
      blueprint2railsGenerator = generator
      blueprint2railsGenerator.instance_variable_set(:@resource_name, "notes")
      template = generator.read_template("controllers/destroy.rb")
      expect(template).to include("def destroy")
      expect(template).to include("@note =")
    end

    it "should return index action template" do
      blueprint2railsGenerator = generator
      blueprint2railsGenerator.instance_variable_set(:@resource_name, "notes")
      template = generator.read_template("controllers/index.rb")
      expect(template).to include("def index")
      expect(template).to include("@notes =")
    end


    it "should return show action template" do
      blueprint2railsGenerator = generator
      blueprint2railsGenerator.instance_variable_set(:@resource_name, "notes")
      template = generator.read_template("controllers/show.rb")
      expect(template).to include("def show")
      expect(template).to include("@note =")
    end
    
    it "should return update action template" do
      blueprint2railsGenerator = generator
      blueprint2railsGenerator.instance_variable_set(:@resource_name, "notes")
      template = generator.read_template("controllers/update.rb")
      expect(template).to include("def update")
      expect(template).to include("@note =")
    end
  
  end

  context "generator on contacts.md file" do 

    it "creates notes model" do
      assert_file "app/models/note.rb"
    end
    
    it "creates json templates for index, create, show, delete on notes resource" do
      assert_file "app/views/notes/index.json.jbuilder"
      assert_file "app/views/notes/create.json.jbuilder"
      assert_file "app/views/notes/show.json.jbuilder"
      assert_file "app/views/notes/destroy.json.jbuilder"
    end

    it "creates notes controller" do
      assert_file "app/controllers/notes_controller.rb"
    end

    it "creates notes routes" do
      assert_file "config/routes.rb"
      expect(File.read("#{TEMP_DIR}/config/routes.rb")).to include("resources :notes, only: [:index, :create, :show, :destroy]")
    end

    it "creates notes migration" do
      file = Dir.glob("#{TEMP_DIR}/db/migrate/*.rb").first
      assert_file(file)
      expect(file).to match(/[0-9]+_create_notes.rb$/)
      expect(File.read(file)).to include("class CreateNotes < ActiveRecord::Migration")
      expect(File.read(file)).to include("create_table :notes do |t|")
    end

  end



end