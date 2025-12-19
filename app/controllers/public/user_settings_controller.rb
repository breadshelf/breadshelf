
module Public
  class UserSettingsController < ApplicationController
    def index
      raise(NotFoundError) if current_user.nil?

      @user_settings = {
        allow_emails: current_user.allow_emails?
      }
    end

    def update
      
    end
  end
end