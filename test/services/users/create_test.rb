require 'test_helper'

class CreateTest < ActiveSupport::TestCase
  test 'returns false with missing user' do
    result = Users::Create.call(nil)

    assert(result == false)
  end

  test 'returns false and updates a user' do
    user = users(:amy)
    user.clerk_id = 'user_1234'
    user.save!

    clerk_user = stub(id: 'user_1234', email_addresses: [stub(email_address: 'amy2@test.com')], first_name: 'First', last_name: 'Last')

    result = Users::Create.call(clerk_user)

    assert(result == false)

    user.reload
    assert(user.email == 'amy2@test.com')
    assert(user.first_name == 'First')
    assert(user.last_name == 'Last')
  end

  test 'returns true and creates a user' do
    clerk_user = stub(id: 'user_1234', email_addresses: [stub(email_address: 'peyton@test.com')], first_name: 'Peyton', last_name: 'Celuch')

    result = Users::Create.call(clerk_user)

    assert(result == true)

    user = User.find_by(clerk_id: 'user_1234')
    assert(user.email == 'peyton@test.com', 'email is wrong')
    assert(user.first_name == 'Peyton', 'first name is wrong')
    assert(user.last_name == 'Celuch', 'last name is wrong')
  end
end
