class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @base_url = "#{ENV['DOMAIN']}"
    @about_url = "#{@base_url}/about"
    attachments.inline['slice.svg'] = File.read(Rails.root.join('app/assets/images/slice.svg'))
    mail(to: @user.email, subject: 'Welcome to breadshelf')
  end
end
