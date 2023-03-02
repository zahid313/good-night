require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "John Doe")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "associated sleep records should be destroyed" do
    @user.save
    @user.sleep_records.create!(start_time: Time.now, end_time: Time.now + 6.hours)
    assert_difference 'SleepRecord.count', -1 do
      @user.destroy
    end
  end

  test "following association is updated when a user follows another user" do
    user1 = users(:one)
    user2 = users(:two)

    assert_difference 'user1.followings.count', 1 do
      Follow.create(follower: user1, following: user2, approved: true)
    end
    
  end

  test "followers association is updated when a user follows another user" do
    user1 = users(:one)
    user2 = users(:two)

    assert_difference 'user2.followers.count', 1 do
      Follow.create(follower: user1, following: user2, approved: true)
    end
  end  

  test "active_follows and passive_follows associations are updated when a user follows another user" do
    user1 = users(:one)
    user2 = users(:two)

    follow = Follow.create(follower: user1, following: user2, approved: true)

    assert_includes user1.active_follows, follow
    assert_includes user2.passive_follows, follow
  end  

  test "friends_sleep_records should return sleep records of friends" do
    friend1 = users(:two)
    friend2 = users(:three)
    friend3 = users(:four)
    sleep_record1 = sleep_records(:one)
    sleep_record2 = sleep_records(:two)
    sleep_record3 = sleep_records(:three)
    sleep_record4 = sleep_records(:four)
    sleep_record5 = sleep_records(:five)
    sleep_record6 = sleep_records(:six)
    sleep_record7 = sleep_records(:seven)
    sleep_record8 = sleep_records(:eight)

    # Create follow records
    Follow.create(follower_id: @user.id, following_id: friend1.id, approved: true)
    Follow.create(follower_id: @user.id, following_id: friend2.id, approved: true)
    Follow.create(follower_id: @user.id, following_id: friend3.id, approved: true)
    # Assign sleep records to friends
    friend1.sleep_records << [sleep_record1, sleep_record2]
    friend2.sleep_records << [sleep_record3, sleep_record4, sleep_record5]
    friend3.sleep_records << [sleep_record6, sleep_record7, sleep_record8]

    sleep_record_ids = [sleep_record1, sleep_record2, sleep_record3, sleep_record4, sleep_record5,
                     sleep_record6,sleep_record7,sleep_record8].map(&:id)
    friend_sleep_ids = @user.friend_sleep_records.map(&:id)  
    # Assert that the method returns the correct sleep records
    assert (friend_sleep_ids & sleep_record_ids) == friend_sleep_ids
  end

  test "friends_sleep_records should return empty array when user has no friends" do
    assert_equal @user.friend_sleep_records.to_a, []
  end  
end
