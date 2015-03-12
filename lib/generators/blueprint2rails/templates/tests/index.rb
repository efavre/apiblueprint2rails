  test "should get index" do
    get :index
    assert_response 200
    assert_not_nil assigns(:<%= plural_name %>)
  end