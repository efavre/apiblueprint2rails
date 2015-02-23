  def show
    @<%= singular_name %> = <%= singular_class_name %>.find(params[:id])
  end