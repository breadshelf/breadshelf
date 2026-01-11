require 'test_helper'

module Public
  class UserTest < ActiveSupport::TestCase
    test 'email must be unique' do
      user1 = User.new(email: 'test@gmail.com')
      user2 = User.new(email: 'test@gmail.com')

      assert(user1.save)
      assert_not(user2.save)
    end

    test 'email must be a valid email' do
      user = User.new(email: 'notanemail')

      assert_not(user.save)
    end

    test 'allow_emails? returns true when setting is enabled' do
      user = User.create!(email: 'test@test.com')
      setting = Public::Setting.find_or_create_by!(name: Setting::Name::ALLOW_EMAILS)
      Public::UserSetting.create!(user: user, setting: setting, enabled: true)

      assert(user.allow_emails?)
    end

    test 'allow_emails? returns false when setting is disabled' do
      user = User.create!(email: 'test@test.com')
      setting = Public::Setting.find_or_create_by!(name: Setting::Name::ALLOW_EMAILS)
      Public::UserSetting.create!(user: user, setting: setting, enabled: false)

      assert_not(user.allow_emails?)
    end


    test 'allow_emails? returns true when setting is not set' do
      user = User.create!(email: 'test@test.com')
      assert(user.allow_emails?)
    end
  end
end
