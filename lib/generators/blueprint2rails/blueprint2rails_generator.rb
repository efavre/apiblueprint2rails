require 'blueprint2rails/blueprint_to_rails_parser'
class Apiblueprint2railsGenerator < Rails::Generators::Base
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)
  # hook_for :resource

  def fake_write_to_console
    p singular_name
    resources = BlueprintToRailsParser.parse()
  end
end
