  def index
    @<%= plural_name %> = <%= singular_class_name %>.all
  end