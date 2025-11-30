require 'test_helper'
require 'mocha/minitest'

class UsersControlerTest < ActionDispatch::IntegrationTest
  test 'displays a sign up prompt when not signed in' do
    get '/users/new'

    assert_response :success
    assert_dom 'p', "Sign up to receive an email when we're ready for you."
  end

  test 'creates a user that does not already exist' do
    mock_user = stub(id: 'user_1234', first_name: 'First', last_name: 'Last', email_addresses: [])
    mock_clerk = stub(user?: true, user: mock_user)

    UsersController.any_instance.stubs(:clerk).returns(mock_clerk)

    get '/users/new'
    assert_response :success
    assert_dom 'p', "You're signed up! We'll update you soon. In the meantime ensure you follow us on social media."

    assert User.last.clerk_id == 'user_1234'
  end

  test 'updates a user that already exists' do
    user = users(:one)
    user.clerk_id = 'user_1234'
    user.save!

    mock_user = stub(id: 'user_1234', first_name: 'First', last_name: 'Last', email_addresses: [])
    mock_clerk = stub(user?: true, user: mock_user)

    UsersController.any_instance.stubs(:clerk).returns(mock_clerk)

    get '/users/new'
    assert_response :success
    assert_dom 'p', "You're signed up! We'll update you soon. In the meantime ensure you follow us on social media."

    updated_user = User.find_by(clerk_id: 'user_1234')
    assert updated_user.first_name == 'First'
  end
end
