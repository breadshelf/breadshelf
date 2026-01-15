
module Public
  module Emails
    class Suppressor < ApplicationService
      def initialize(email)
        @email = email
      end

      def call
        user = Public::User.find_by(email: email)
        return unless user

        user_setting = user.user_settings.find_or_create_by!(
          setting: Public::Setting.find_by(name: Public::Setting::Name::ALLOW_EMAIL)
        )
        user_setting.update!(value: false)
      end
    end
  end
end
