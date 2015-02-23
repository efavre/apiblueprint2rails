  def destroy
    @<%= singular_name %> = <%= singular_class_name %>.find(params[:id])
    @<%= singular_name %>.destroy
  end