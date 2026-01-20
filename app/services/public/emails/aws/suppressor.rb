
module Public
  class Emails::Aws::Suppressor < ApplicationService
    def initialize(json)
      @json = json
      @message = JSON.parse(@json['Message'])
    end

    def call
      emails = parse_emails_from_event
      return unless emails

      emails.each do |email|
        suppress_email(email)
      end
    end

    private

    def parse_emails_from_event
      Rails.logger.info('Public::Emails::Aws::Suppressor - Processing email suppression for event type: ' + @message['notificationType'])
      case @message['notificationType']
      when 'Bounce'
        bounce = @message['bounce']
        recipients = bounce['bouncedRecipients']
        emails = recipients.map { |r| r['emailAddress'] }
      when 'Complaint'
        complaint = @message['complaint']
        recipients = complaint['complainedRecipients']
        emails = recipients.map { |r| r['emailAddress'] }
      end

      emails
    end

    def suppress_email(email)
      user = Public::User.find_by(email: email)
      return unless user

      Rails.logger.info('Public::Emails::Aws::Suppressor - Suppressing email for user ID: ' + user.id.to_s + ', email: ' + email)
      user_setting = user.user_settings.find_or_create_by!(
        setting: Public::Setting.find_by(name: Public::Setting::Name::ALLOW_EMAILS)
      )
      user_setting.update!(enabled: false)
    end
  end
end
