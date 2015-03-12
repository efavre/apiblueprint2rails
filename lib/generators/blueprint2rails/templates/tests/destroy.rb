  test "should destroy <%= singular_name %>" do
    post :destroy
    assert_response 204
  end