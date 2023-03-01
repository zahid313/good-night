require 'test_helper'

class Api::V1::FriendSleepRecordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john) 
    @friend = users(:jane) 
    @sleep_record = sleep_records(:jane) 
    @friendship = Follow.create(follower: @user, following: @friend, approved: true) # assuming the friendship is already established
  end

  test "should get friend sleep records for past week" do
    get api_v1_friends_sleep_records_path(user_id: @user.id), as: :json
    assert_response :success
    assert_not_nil assigns(:sleep_records)
    assert assigns(:sleep_records).all? { |record| record.user == @friend }
    assert assigns(:sleep_records).all? { |record| record.end_time >= 1.week.ago }
    assert assigns(:sleep_records).sort_by(&:duration).reverse.map(&:duration) == assigns(:sleep_records).map(&:duration).sort.reverse
  end

  test "should return empty array if friend does not have any sleep records" do
    SleepRecord.where(user_id: @friend.id).destroy_all
    get api_v1_friends_sleep_records_path(user_id: @user.id), as: :json
    assert_response :success
    assert_not_nil assigns(:sleep_records)
    assert_empty assigns(:sleep_records)
  end

  test "should return empty array if friend is not found" do
    get api_v1_friends_sleep_records_path(user_id: @user.id), as: :json
    assert_response :success
    assert assigns(:sleep_records), []
  end

  test "should return empty array if user is not friends with the friend" do
    friend = users(:bob)
    get api_v1_friends_sleep_records_path(user_id: friend.id), as: :json
    assert_response :success
    assert assigns(:sleep_records), []
  end
end
