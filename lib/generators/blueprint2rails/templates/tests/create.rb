  test "should create <%= singular_name %>" do
    post :create
    assert_response 201
    assert_not_nil assigns(:<%= singular_name %>)
  end