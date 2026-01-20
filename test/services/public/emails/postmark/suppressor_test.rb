require 'test_helper'

module Public
  class Emails::Postmark::SuppressorTest < ActiveSupport::TestCase
    setup do
      @setting = Public::Setting.create!(name: Public::Setting::Name::ALLOW_EMAILS)
    end

    # Test: Email Suppression
    test 'suppresses email when valid email is provided' do
      user = users(:amy)
      email = user.email

      event = {
        'RecordType' => 'Bounce',
        'Email' => email
      }

      Public::Emails::Postmark::Suppressor.call(event)

      user.reload
      user_setting = user.user_settings.find_by(setting: @setting)
      assert_not_nil(user_setting, 'User setting should be created')
      assert_equal(false, user_setting.enabled, 'Email should be suppressed')
    end

    test 'does not create setting if user does not exist' do
      non_existent_email = 'nonexistent@test.com'

      event = {
        'RecordType' => 'Bounce',
        'Email' => non_existent_email
      }

      assert_no_difference('Public::UserSetting.count') do
        Public::Emails::Postmark::Suppressor.call(event)
      end
    end

    # Test: Handling missing email
    test 'returns early if email is missing from event' do
      event = {
        'RecordType' => 'Bounce'
      }

      assert_no_difference('Public::UserSetting.count') do
        Public::Emails::Postmark::Suppressor.call(event)
      end
    end

    test 'returns early if email is nil' do
      event = {
        'RecordType' => 'Bounce',
        'Email' => nil
      }

      assert_no_difference('Public::UserSetting.count') do
        Public::Emails::Postmark::Suppressor.call(event)
      end
    end

    test 'returns early if email is empty string' do
      event = {
        'RecordType' => 'Bounce',
        'Email' => ''
      }

      assert_no_difference('Public::UserSetting.count') do
        Public::Emails::Postmark::Suppressor.call(event)
      end
    end

    # Test: User with existing settings
    test 'updates existing user setting' do
      user = users(:amy)
      email = user.email

      # Create initial setting with enabled = true
      user_setting = user.user_settings.create!(
        setting: @setting,
        enabled: true
      )

      event = {
        'RecordType' => 'Bounce',
        'Email' => email
      }

      Public::Emails::Postmark::Suppressor.call(event)

      user_setting.reload
      assert_equal(false, user_setting.enabled)
    end
  end
end
