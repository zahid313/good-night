require 'test_helper'

class SleepRecordTest < ActiveSupport::TestCase
  test "should save sleep record with all required attributes" do
    user = User.create(name: "John Doe")
    sleep_record = SleepRecord.new(user: user, start_time: Time.now, end_time: Time.now + 8.hours)
    assert sleep_record.save, true
  end

  test "should not save sleep record without user" do
    sleep_record = SleepRecord.new(start_time: Time.now, end_time: Time.now + 8.hours)
    assert_not sleep_record.save, true
  end

  test "should not save sleep record without start time" do
    user = User.create(name: "John Doe")
    sleep_record = SleepRecord.new(user: user, end_time: Time.now + 8.hours)
    assert_not sleep_record.save, true
  end

  test "should not save sleep record without end time" do
    user = User.create(name: "John Doe")
    sleep_record = SleepRecord.new(user: user, start_time: Time.now)
    assert_not sleep_record.save, true
  end

  test "should not allow sleep periods longer than 24 hours" do
    user = User.create(name: "John Doe")
    sleep_record = SleepRecord.new(user: user, start_time: Time.now, end_time: Time.now + 25.hours)
    assert_not sleep_record.save, true
  end

  test "end time must be after start time" do
    user = User.create(name: "John Doe")
    sleep_record = SleepRecord.new(user: user, start_time: Time.now, end_time: Time.now - 8.hours)
    assert_not sleep_record.save, true
  end  

    test "calculate_duration returns difference between start_time and end_time in seconds" do
      sleep_record = SleepRecord.new(start_time: Time.now - 1.hour, end_time: Time.now)
      assert_equal 60, sleep_record.calculate_duration
    end
    
    test "calculate_duration returns nil if end_time is not present" do
      sleep_record = SleepRecord.new(start_time: Time.now - 1.hour, end_time: nil)
      assert_nil sleep_record.calculate_duration
    end
    
    test "calculate_duration returns nil if start_time is not present" do
      sleep_record = SleepRecord.new(start_time: nil, end_time: Time.now)
      assert_nil sleep_record.calculate_duration
    end
    
    test "calculate_duration returns nil if both start_time and end_time are not present" do
      sleep_record = SleepRecord.new(start_time: nil, end_time: nil)
      assert_nil sleep_record.calculate_duration
    end

end
