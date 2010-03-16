require 'test_helper'

class UserappsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:userapps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create userapp" do
    assert_difference('Userapp.count') do
      post :create, :userapp => { }
    end

    assert_redirected_to userapp_path(assigns(:userapp))
  end

  test "should show userapp" do
    get :show, :id => userapps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => userapps(:one).to_param
    assert_response :success
  end

  test "should update userapp" do
    put :update, :id => userapps(:one).to_param, :userapp => { }
    assert_redirected_to userapp_path(assigns(:userapp))
  end

  test "should destroy userapp" do
    assert_difference('Userapp.count', -1) do
      delete :destroy, :id => userapps(:one).to_param
    end

    assert_redirected_to userapps_path
  end
end
