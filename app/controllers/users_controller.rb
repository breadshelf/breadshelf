
class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def new
    @user = User.new
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
