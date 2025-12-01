require 'test_helper'
require 'mocha/minitest'

class UsersControllerTest < ActionDispatch::IntegrationTest
  class LandingTests < UsersControllerTest
    test 'displays a sign up prompt when not signed in' do
      clerk_sign_out

      get '/'

      assert_response :success
      assert_dom 'p', "Sign up to receive an email when we're ready for you."
    end

    test 'returns a signed up prompt when user exists' do
      clerk_sign_in(user_attrs: { id: 'user_1234' })

      get '/'
      assert_response :success
      assert_dom 'p', "You're signed up! We'll update you soon. In the meantime ensure you follow us on social media."
    end
  end

  class SignInTests < UsersControllerTest
    test 'returns a 201 if the user was created' do
      clerk_sign_out

      Users::Create.stubs(:call).returns(true)

      put '/users/sign_in'

      assert_response :created
    end

    test 'returns a 200 if the user was updated' do
      clerk_sign_out

      Users::Create.stubs(:call).returns(false)

      put '/users/sign_in'

      assert_response :ok
    end
  end
end
