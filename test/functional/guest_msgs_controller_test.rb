require 'test_helper'

class GuestMsgsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:guest_msgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create guest_msg" do
    assert_difference('GuestMsg.count') do
      post :create, :guest_msg => { }
    end

    assert_redirected_to guest_msg_path(assigns(:guest_msg))
  end

  test "should show guest_msg" do
    get :show, :id => guest_msgs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => guest_msgs(:one).to_param
    assert_response :success
  end

  test "should update guest_msg" do
    put :update, :id => guest_msgs(:one).to_param, :guest_msg => { }
    assert_redirected_to guest_msg_path(assigns(:guest_msg))
  end

  test "should destroy guest_msg" do
    assert_difference('GuestMsg.count', -1) do
      delete :destroy, :id => guest_msgs(:one).to_param
    end

    assert_redirected_to guest_msgs_path
  end
end
