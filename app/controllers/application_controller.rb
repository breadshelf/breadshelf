class ApplicationController < ActionController::Base
  include Clerk::Authenticatable

  class NotFoundError < StandardError; end
  class InternalStatusError < StandardError; end

  rescue_from(NotFoundError, with: :not_found)
  rescue_from(InternalStatusError, with: :internal_error)

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def current_user
    Public::User.find_by(clerk_id: clerk.user.id) if clerk.user?
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def internal_error
    render file: "#{Rails.root}/public/500.html", status: :internal_service_error, layout: false
  end
end
