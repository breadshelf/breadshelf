require 'test_helper'
require 'mocha/minitest'

class UsersControlerTest < ActionDispatch::IntegrationTest
  test 'displays a sign up prompt when not signed in' do
    clerk_sign_out

    get '/users/new'

    assert_response :success
    assert_dom 'p', "Sign up to receive an email when we're ready for you."
  end

  test 'creates a user that does not already exist' do
    clerk_sign_in(user_attrs: { id: 'user_1234' })

    get '/users/new'
    assert_response :success
    assert_dom 'p', "You're signed up! We'll update you soon. In the meantime ensure you follow us on social media."

    assert User.last.clerk_id == 'user_1234'
  end

  test 'updates a user that already exists' do
    user = users(:noah)
    user.clerk_id = 'user_1234'
    user.save

    clerk_sign_in(user_attrs: {
      id: 'user_1234',
      first_name: 'First',
      last_name: 'Last',
      email_addresses: [stub(email_address: user.email)]
    })

    get '/users/new'
    assert_response :success
    assert_dom 'p', "You're signed up! We'll update you soon. In the meantime ensure you follow us on social media."

    updated_user = User.find_by(clerk_id: 'user_1234')
    assert updated_user.first_name == 'First'
  end
end
