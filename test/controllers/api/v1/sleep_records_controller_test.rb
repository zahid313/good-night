require 'test_helper'

class Api::V1::SleepRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @sleep_record = sleep_records(:one)
    @valid_sleep_record_params = { start_time: Time.zone.now, end_time: Time.zone.now + 8.hours }
    @invalid_sleep_record_params = { start_time: Time.zone.now, end_time: Time.zone.now - 8.hours }
  end

  test "should get index" do
    get api_v1_sleep_records_url(user_id: @user.id), as: :json
    assert_response :success
  end

  test "should create sleep record" do
    assert_difference('SleepRecord.count') do
      post api_v1_sleep_records_url, params: { user_id: @user.id, sleep_record: @valid_sleep_record_params }, as: :json
    end
    assert_response :created
  end

  test "should update sleep record" do
    patch api_v1_sleep_record_url(@sleep_record), params: { sleep_record: @valid_sleep_record_params, user_id: @user.id }, as: :json
    assert_response :success
  end

  test "should not create invalid sleep record" do
    assert_no_difference('SleepRecord.count') do
      post api_v1_sleep_records_url, params: { user_id: @user.id, sleep_record: @invalid_sleep_record_params }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "should not create sleep record without user id" do
    assert_no_difference('SleepRecord.count') do
      post api_v1_sleep_records_url, params: { sleep_record: @valid_sleep_record_params }, as: :json
    end
    assert_response :not_found
  end
end
