class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @base_url = "#{ENV['DOMAIN']}/"
    @about_url = "#{@base_url}/about"
    mail(to: @user.email, subject: 'Welcome to breadshelf')
  end
end
