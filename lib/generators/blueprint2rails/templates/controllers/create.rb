  def create
    @<%= singular_name %> = <%= singular_class_name %>.new(params[:<%= singular_name %>])
    if @<%= singular_name %>.save

    else
      
    end
  end