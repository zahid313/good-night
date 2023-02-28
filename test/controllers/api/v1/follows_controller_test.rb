require 'test_helper'

class Api::V1::FollowsControllerTest < ActionDispatch::IntegrationTest
  test "should follow user" do
    user = User.create(name: "John")
    other_user = User.create(name: "Jane")
    assert_difference('Follow.count') do
      post api_v1_follows_path, params: { user_id: user.id, id: other_user.id}
    end
    assert_response :success
  end

  test "should not follow invalid user" do
    user = User.create(name: "John")
    assert_no_difference('Follow.count') do
      post api_v1_follows_path, params: { user_id: user.id, id: 999}
    end
    assert_response :not_found
  end

  test "should unfollow user" do
    user = User.create(name: "John")
    other_user = User.create(name: "Jane")
    follow = Follow.create(follower_id: user.id, following_id: other_user.id)
    assert_difference('Follow.count', -1) do
      delete api_v1_follow_path(other_user.id), params: {user_id: user.id}
    end
    assert_response :success
  end

  test "should not unfollow invalid follow" do
    user = User.create(name: "John")
    assert_no_difference('Follow.count') do
      delete api_v1_follow_path(999), params: {user_id: user.id}
    end
    assert_response :not_found
  end
end
