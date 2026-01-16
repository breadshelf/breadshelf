require 'test_helper'

module Public
  module Emails
    class SuppressorTest < ActiveSupport::TestCase
      setup do
        Setting.create!(name: Public::Setting::Name::ALLOW_EMAILS)
      end

      test 'suppresses email on bounce event' do
        user = users(:amy)
        email = user.email

        bounce_event = {
          'Message' => {
            'notificationType' => 'Bounce',
            'bounce' => {
              'bouncedRecipients' => [
                { 'emailAddress' => email }
              ]
            }
          }.to_json
        }

        Public::Emails::Suppressor.call(bounce_event)

        user_setting = user.user_settings.find_by(setting: Public::Setting.find_by(name: Public::Setting::Name::ALLOW_EMAILS))
        assert_not_nil(user_setting, 'User setting should be created')
        assert_equal(false, user_setting.enabled, 'Email should be suppressed')
      end

      test 'suppresses email on complaint event' do
        user = users(:noah)
        email = user.email

        complaint_event = {
          'Message' => {
            'notificationType' => 'Complaint',
            'complaint' => {
              'complainedRecipients' => [
                { 'emailAddress' => email }
              ]
            }
          }.to_json
        }

        Public::Emails::Suppressor.call(complaint_event)

        user_setting = user.user_settings.find_by(setting: Public::Setting.find_by(name: Public::Setting::Name::ALLOW_EMAILS))
        assert_not_nil(user_setting, 'User setting should be created')
        assert_equal(false, user_setting.enabled, 'Email should be suppressed')
      end
    end
  end
end
