require 'test_helper'

class PubsetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pubsets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pubset" do
    assert_difference('Pubset.count') do
      post :create, :pubset => { }
    end

    assert_redirected_to pubset_path(assigns(:pubset))
  end

  test "should show pubset" do
    get :show, :id => pubsets(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pubsets(:one).to_param
    assert_response :success
  end

  test "should update pubset" do
    put :update, :id => pubsets(:one).to_param, :pubset => { }
    assert_redirected_to pubset_path(assigns(:pubset))
  end

  test "should destroy pubset" do
    assert_difference('Pubset.count', -1) do
      delete :destroy, :id => pubsets(:one).to_param
    end

    assert_redirected_to pubsets_path
  end
end
