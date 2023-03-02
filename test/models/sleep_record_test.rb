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

  test "should save sleep record without end time" do
    user = User.create(name: "John Doe")
    sleep_record = SleepRecord.new(user: user, start_time: Time.now)
    assert sleep_record.save, true
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

    class ValidateSleepRecordTest < ActiveSupport::TestCase
      def setup
        @user = users(:one)
        @existing_sleep_record = sleep_records(:four)
      end

      test "Sleep record with end_time overlapping with existing record" do
        new_sleep_record = SleepRecord.new(
          user: @user,
          start_time: @existing_sleep_record.start_time - 1.hour,
          end_time: @existing_sleep_record.end_time + 1.hour
        )
        assert_not new_sleep_record.valid?
        assert_includes new_sleep_record.errors.full_messages, "Sleep record conflicts with existing record"        
      end

      test "Sleep record with start_time overlapping with existing record" do
        new_sleep_record = SleepRecord.new(
          user: @user,
          start_time: @existing_sleep_record.start_time + 1.hour,
          end_time: @existing_sleep_record.end_time - 1.hour
        )
        assert_not new_sleep_record.valid?
        assert_includes new_sleep_record.errors.full_messages, "Sleep record conflicts with existing record"
      end

      test "Sleep record completely within existing record" do
        new_sleep_record = SleepRecord.new(
          user: @user,
          start_time: @existing_sleep_record.start_time + 1.hour,
          end_time: @existing_sleep_record.end_time - 1.hour
        )
        assert_not new_sleep_record.valid?
        assert_includes new_sleep_record.errors.full_messages, "Sleep record conflicts with existing record"
      end      

      test "Sleep record with no overlap" do
        new_sleep_record = SleepRecord.new(
          user: @user,
          start_time: @existing_sleep_record.end_time + 1.day,
          end_time: @existing_sleep_record.end_time + 30.hours
        )
        assert new_sleep_record.valid?
      end     
      
      test 'should not allow two sleep records per day per user' do
        start_time = Time.now
        SleepRecord.create(start_time: start_time, end_time: start_time + 8.hours, user: @user)
        sleep_record = SleepRecord.new(start_time: start_time, end_time: start_time + 9.hours, user: @user)
        assert_not sleep_record.valid?
      end
    
      test 'should not allow a new record to be created if there is an active sleep record for user' do
        sleep_record = SleepRecord.create(start_time: Time.now, user: @user)
        sleep_record2 = SleepRecord.new(start_time: Time.now + 1.day, user: @user)
        assert_not sleep_record2.valid?
      end      
    end 

end
