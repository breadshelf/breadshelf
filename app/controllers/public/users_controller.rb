
module Public
  class UsersController < ApplicationController
    def landing
      if Flipper.enabled?(:mvp)
        redirect_to new_entry_path
        return
      end

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

      Public::Users::Settings::Update.call(current_user, settings_params)

      redirect_to '/users/settings', notice: { message: 'Settings updated', status: 'success' }
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
