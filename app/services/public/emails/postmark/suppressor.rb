
module Public
  class Emails::Postmark::Suppressor < ApplicationService
    def initialize(json)
      @json = json
    end

    def call
      email = parse_email_from_event
      return unless email

      suppress_email(email)
    end

    private

    def parse_email_from_event
      Rails.logger.info('Public::Emails::Postmark::Suppressor - Processing email suppression for event type: ' + @json['RecordType'].to_s)
      
      @json['Email']
    end

    def suppress_email(email)
      user = Public::User.find_by(email: email)
      return unless user

      Rails.logger.info('Public::Emails::Postmark::Suppressor - Suppressing email for user ID: ' + user.id.to_s + ', email: ' + email)
      user_setting = user.user_settings.find_or_create_by!(
        setting: Public::Setting.find_by(name: Public::Setting::Name::ALLOW_EMAILS)
      )
      user_setting.update!(enabled: false)
    end
  end
end
