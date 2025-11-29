
class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def new
    @user_exists = clerk.user?

    if @user_exists
      @clerk_user = clerk.user

      @user = User.find_by(clerk_id: @clerk_user.id)
      if @user
        @user.email = @clerk_user.email_addresses.first&.email_address
        @user.first_name = @clerk_user.first_name
        @user.last_name = @clerk_user.last_name
      else
        @user = User.create(
          clerk_id: @clerk_user.id,
          unique_id: SecureRandom.uuid_v4,
          email: @clerk_user.email_addresses.first&.email_address,
          first_name: @clerk_user.first_name,
          last_name: @clerk_user.last_name
        )
        UserMailer.with(user: @user).welcome_email.deliver_later
      end
    end
  end

  def show
  end

  def create
    @user = User.new(sign_up_params)

    if @user.save
      respond_to do |format|
        format.html { redirect_to @user }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def sign_up_params
    params.require(:user).permit(:email)
  end
end
