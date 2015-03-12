  test "should update <%= singular_name %>" do
    <%= singular_name %> = <%= singular_class_name %>.create
    put :update, id:<%= singular_name %>.id, <%= singular_name %>:{attribute:"new_value"}
    assert_response 200
    assert_not_nil assigns(:<%= singular_name %>)
  end