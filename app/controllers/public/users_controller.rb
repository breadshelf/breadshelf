
module Public
  class UsersController < ApplicationController
    before_action :set_user, only: [:show]

    def landing
      @user_exists = clerk.user?
      Analytics::Events::PageView.call(request.path)
    end

    def show
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

    private

    def set_user
      @user = Public::User.find(params[:id])
    end

    def sign_up_params
      params.require(:user).permit(:email)
    end
  end
end
