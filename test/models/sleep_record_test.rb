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
    assert_not sleep_record.save!, true
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
end
