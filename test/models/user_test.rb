require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user with a name is valid" do
    user = User.new(name: "John Doe")
    assert user.valid?
  end

  test "user without a name is invalid" do
    user = User.new
    assert_not user.valid?
  end
end
