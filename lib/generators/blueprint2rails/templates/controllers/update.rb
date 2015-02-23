  def update
    @<%= singular_name %> = <%= singular_class_name %>.find(params[:id])
    if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])

    else

    end
  end