require 'test_helper'

module Public
  class UserTest < ActiveSupport::TestCase
    test 'email must be unique for authenticated users' do
      user1 = User.create!(email: 'test@gmail.com', clerk_id: 'clerk_1')
      user2 = User.new(email: 'test@gmail.com', clerk_id: 'clerk_2')

      assert_not(user2.save)
    end

    test 'email can be blank for anonymous users' do
      user = User.create!(anonymous: true)

      assert user.persisted?
      assert_nil user.email
    end

    test 'email must be a valid email when present' do
      user = User.new(email: 'notanemail', clerk_id: 'clerk_1')

      assert_not(user.save)
    end

    test 'clerk_id is required for authenticated users' do
      user = User.new(email: 'test@test.com', anonymous: false)

      assert_not(user.save)
    end

    test 'clerk_id is not required for anonymous users' do
      user = User.create!(anonymous: true, email: nil)

      assert user.persisted?
    end

    test 'allow_emails? returns true when setting is enabled' do
      user = User.create!(email: 'test@test.com', clerk_id: 'clerk_1')
      setting = Public::Setting.find_or_create_by!(name: Setting::Name::ALLOW_EMAILS)
      Public::UserSetting.create!(user: user, setting: setting, enabled: true)

      assert(user.allow_emails?)
    end

    test 'allow_emails? returns false when setting is disabled' do
      user = User.create!(email: 'test@test.com', clerk_id: 'clerk_1')
      setting = Public::Setting.find_or_create_by!(name: Setting::Name::ALLOW_EMAILS)
      Public::UserSetting.create!(user: user, setting: setting, enabled: false)

      assert_not(user.allow_emails?)
    end

    test 'allow_emails? returns true when setting is not set' do
      user = User.create!(email: 'test@test.com', clerk_id: 'clerk_1')
      assert(user.allow_emails?)
    end

    test 'allow_emails? returns false for anonymous users' do
      user = User.create!(anonymous: true)
      assert_not(user.allow_emails?)
    end
  end
end
