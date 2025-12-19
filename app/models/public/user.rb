module Public
  class User < ApplicationRecord
    has_many(:user_settings)

    validates_uniqueness_of(:email)
    validates(:email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' })

    def allow_emails?
      setting = user_settings
        .joins(:setting)
        .find_by(settings: { name: Public::Setting::Name::ALLOW_EMAILS })
      setting ? setting.enabled : false
    end
  end
end
