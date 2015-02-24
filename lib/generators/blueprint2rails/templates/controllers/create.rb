  def create
    @<%= singular_name %> = <%= singular_class_name %>.new(params[:<%= singular_name %>])
    if @<%= singular_name %>.save
      render status: 201
    else
      render status: 403
    end
  end