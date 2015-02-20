require 'generator_spec'
require 'generators/blueprint2rails/blueprint2rails_generator'

describe Blueprint2railsGenerator, type: :generator do

  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(spec/test_files/contacts.md)

  before(:all) do
    prepare_destination
    run_generator
  end

  context "generator on contacts.md fils" do 
    it "creates json templates for index, create, show, delete on notes resource" do
      assert_file "app/views/notes/index.json.jbuilder"
      assert_file "app/views/notes/create.json.jbuilder"
      assert_file "app/views/notes/show.json.jbuilder"
      assert_file "app/views/notes/delete.json.jbuilder"
    end
  end
end