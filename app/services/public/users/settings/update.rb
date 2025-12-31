
module Public
  class Users::Settings::Update < ApplicationService
    def initialize(user, settings)
      @user = user
      @settings = settings
    end

    def call
      allow_emails = @settings[:allow_emails]
      setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)
      user_setting = @user.user_settings.find_or_create_by!(setting_id: setting.id)
      user_setting.update!(enabled: allow_emails == '1')
    end
  end
end
