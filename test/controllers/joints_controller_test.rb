require 'test_helper'

class JointsControllerTest < ActionController::TestCase
  setup do
    @joint = joints(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:joints)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create joint" do
    assert_difference('Joint.count') do
      post :create, joint: { food_id: @joint.food_id, sub_id: @joint.sub_id }
    end

    assert_redirected_to joint_path(assigns(:joint))
  end

  test "should show joint" do
    get :show, id: @joint
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @joint
    assert_response :success
  end

  test "should update joint" do
    patch :update, id: @joint, joint: { food_id: @joint.food_id, sub_id: @joint.sub_id }
    assert_redirected_to joint_path(assigns(:joint))
  end

  test "should destroy joint" do
    assert_difference('Joint.count', -1) do
      delete :destroy, id: @joint
    end

    assert_redirected_to joints_path
  end
end
