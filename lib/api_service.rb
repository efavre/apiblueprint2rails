class ApiService

  attr_accessor :http_verb, :is_collection

  def initialize(http_verb)
    @http_verb = http_verb
  end

end