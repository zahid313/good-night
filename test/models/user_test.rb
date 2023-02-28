require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "John Doe")
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

  test "following and followers association is updated when a user follows another user" do
    user1 = users(:one)
    user2 = users(:two)

    assert_difference 'user1.following.count', 1 do
      Follow.create(follower: user1, following: user2, approved: true)
    end

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
end
