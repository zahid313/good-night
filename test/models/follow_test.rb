require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  def setup
    @follower = User.create(name: 'Follower')
    @following = User.create(name: 'Following')
    @follow = Follow.new(follower_id: @follower.id, following_id: @following.id)
  end

  test 'should be valid' do
    assert @follow.valid?
  end

  test 'follower_id should be present' do
    @follow.follower_id = nil
    assert_not @follow.valid?
  end

  test 'following_id should be present' do
    @follow.following_id = nil
    assert_not @follow.valid?
  end

  test 'should belong to follower' do
    assert_instance_of User, @follow.follower
  end

  test 'should belong to following' do
    assert_instance_of User, @follow.following
  end

  test 'approve should set approved to true' do
    @follow.approve
    assert @follow.reload.approved
  end

  test 'reject should set remove follow request' do
    @follow.reject
    assert_nil @follow.id
  end

  test 'should not allow user to follow same user more than once' do
    user1 = users(:one)
    user2 = users(:two)
    Follow.create(follower_id: user1.id, following_id: user2.id)
    follow = Follow.new(follower_id: user1.id, following_id: user2.id)
    assert_not follow.valid?, 'Should not be able to follow the same user more than once'
  end  
end
