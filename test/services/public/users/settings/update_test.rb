require 'test_helper'

module Public
  class Users::Settings::UpdateTest < ActiveSupport::TestCase
    setup do
      @user = users(:amy)
    end

    test 'creates an allow_emails setting and enables it when passed "1"' do
      @user.user_settings.destroy_all
      setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)

      Users::Settings::Update.call(@user, { allow_emails: '1' })

      user_setting = @user.user_settings.find_by(setting_id: setting.id)
      assert(user_setting.enabled)
    end

    test 'disables an existing allow_emails when passed "0"' do
      setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)
      user_setting = Public::UserSetting.find_or_create_by!(user_id: @user.id, setting_id: setting.id) do |us|
        us.enabled = true
      end

      Users::Settings::Update.call(@user, { allow_emails: '0' })

      user_setting.reload
      assert_not(user_setting.enabled)
      assert_equal(Public::UserSetting.all.count, 1)
    end

    test 'updates existing user_setting to be true' do
      setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)
      user_setting = Public::UserSetting.find_or_create_by!(user_id: @user.id, setting_id: setting.id) do |us|
        us.enabled = false
      end

      Users::Settings::Update.call(@user, { allow_emails: '1' })

      user_setting.reload
      assert(user_setting.enabled)
    end

    test 'handles nil settings parameter gracefully' do
      setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)
      @user.user_settings.destroy_all

      # When checkbox is unchecked, params might be empty
      Users::Settings::Update.call(@user, {})

      user_setting = @user.user_settings.find_by(setting_id: setting.id)
      assert_not_nil(user_setting)
      assert_not(user_setting.enabled)
    end
  end
end
