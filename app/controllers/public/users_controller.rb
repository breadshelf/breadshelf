
module Public
  class UsersController < ApplicationController

    def landing
      @user_exists = clerk.user?
      Analytics::Events::PageView.call(request.path)
    end

    def sign_in
      created = Public::Users::Create.call(clerk.user)

      email_address = clerk.user&.email_addresses&.first&.email_address
      if created
        Analytics::Events::SignUp.call(email_address)
      else
        Analytics::Events::SignIn.call(email_address)
      end

      render json: {}, status: created ? :created : :ok
    end

    def settings
      raise(NotFoundError) if current_user.nil?

      @user_settings = {
        allow_emails: current_user.allow_emails?
      }
    end

    def update_settings
      raise(NotFoundError) if current_user.nil?

      allow_emails = settings_params[:allow_emails] == '1'
      allow_email_setting = Public::Setting.find_or_create_by!(name: Public::Setting::Name::ALLOW_EMAILS)
      user_setting = current_user.user_settings.find_or_create_by!(setting_id: allow_email_setting.id)
      user_setting.update!(enabled: allow_emails)
  
      redirect_to '/users/settings', notice: 'Settings updated successfully'
    end

    private

    def sign_up_params
      params.require(:user).permit(:email)
    end

    def settings_params
      params.permit(:allow_emails)
    end
  end
end
