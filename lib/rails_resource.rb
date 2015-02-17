class RailsResource

  attr_accessor :resource_name, :api_services

  def initialize(resource_name)
    @resource_name = resource_name
  end

end