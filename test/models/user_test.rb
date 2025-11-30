require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'email must be unique' do
    user1 = User.new(email: 'test@gmail.com')
    user2 = User.new(email: 'test@gmail.com')

    assert user1.save
    assert_not user2.save
  end

  test 'email must be a valid email' do
    user = User.new(email: 'notanemail')

    assert_not user.save
  end
end
