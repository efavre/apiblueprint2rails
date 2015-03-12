  test "should show <%= singular_name %>" do
    <%= singular_name %> = <%= singular_class_name %>.create
    get :show, id:<%= singular_name %>.id
    assert_response 200
    assert_not_nil assigns(:<%= singular_name %>)
  end