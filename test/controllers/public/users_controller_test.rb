require 'test_helper'
require 'mocha/minitest'

module Public
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
        assert_dom 'p', "You're signed up! We'll update you soon. In the meantime, make sure you're following us on social media!"
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

    class SettingsTests < UsersControllerTest
      test 'requires authentication' do
        clerk_sign_out
        get '/users/settings'

        assert_response :not_found
      end

      test 'displays user settings when authenticated' do
        user = users(:amy)

        setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)
        Public::UserSetting.find_or_create_by!(user_id: user.id, setting_id: setting.id) do |us|
          us.enabled = true
        end

        clerk_sign_in(user_attrs: { id: user.clerk_id })

        get '/users/settings'

        assert_response :success
        assert_dom('input[type="checkbox"][name="allow_emails"][checked="checked"]')
      end
    end

    class MVPFlagTests < UsersControllerTest
      test 'shows landing page to authenticated users when mvp flag is disabled' do
        clerk_sign_out
        Flipper.disable(:mvp)

        get '/'

        assert_response :success
      end

      test 'shows landing page to unauthenticated users regardless of mvp flag' do
        clerk_sign_out
        Flipper.enable(:mvp)

        get '/'

        assert_redirected_to new_entry_path
      end
    end
  end
end
