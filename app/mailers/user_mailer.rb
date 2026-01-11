class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @base_url = "#{ENV['DOMAIN']}"
    @about_url = "#{@base_url}/about"
    @settings_url = "#{@base_url}/users/settings"
    attachments.inline['slice.png'] = File.read(Rails.root.join('app/assets/images/slice.png'))
    attachments.inline['crumbs.png'] = File.read(Rails.root.join('app/assets/images/crumbs.png'))
    mail(to: @user.email, subject: 'Welcome to breadshelf')
  end
end
