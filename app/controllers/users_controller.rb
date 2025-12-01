
class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def landing
    @user_exists = clerk.user?
  end

  def show
  end

  def sign_in
    created = Users::Create.call(clerk.user)

    render json: {}, status: created ? :created : :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def sign_up_params
    params.require(:user).permit(:email)
  end
end
