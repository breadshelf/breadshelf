
class AdminController < ApplicationController
  before_action :require_admin_auth

  def require_admin_auth
    email_address = clerk.user&.email_addresses&.first&.email_address

    unless email_address == ENV['ADMIN_EMAIL']
      raise(NotFoundError)
    end
  end
end
