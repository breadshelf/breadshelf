
module Public
  class Users::Create < ApplicationService
    def initialize(clerk_user)
      @clerk_user = clerk_user
    end

    def call
      return false if @clerk_user.nil?

      created = false
      user = User.find_by(clerk_id: @clerk_user.id)
      if user
        user.email = @clerk_user.email_addresses.first&.email_address
        user.first_name = @clerk_user.first_name
        user.last_name = @clerk_user.last_name
        user.save!
      else
        # User is signing up for the first time
        created = true
        user = User.create!(
          clerk_id: @clerk_user.id,
          email: @clerk_user.email_addresses.first&.email_address,
          first_name: @clerk_user.first_name,
          last_name: @clerk_user.last_name
        )
        UserSetting.create!(
          user: user,
          setting: Setting.find_by(name: Public::Setting::Name::ALLOW_EMAILS),
          enabled: true
        )
        UserMailer.with(user: user).welcome_email.deliver_later
      end

      created
    end
  end
end
