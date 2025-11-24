
class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def new
    @user_exists = clerk.user?

    if @user_exists
      @clerk_user = clerk.user
      @user = User.find_or_create_by(clerk_id: @clerk_user.id) do |user|
        user.unique_id = SecureRandom.uuid_v4
        user.email = @clerk_user.email_addresses.first&.email_address
        user.first_name = @clerk_user.first_name
        user.last_name = @clerk_user.last_name
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
