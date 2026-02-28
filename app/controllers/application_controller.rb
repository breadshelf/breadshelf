class ApplicationController < ActionController::Base
  include Clerk::Authenticatable

  class NotFoundError < StandardError; end
  class InternalStatusError < StandardError; end

  rescue_from(NotFoundError, with: :not_found)
  rescue_from(InternalStatusError, with: :internal_server_error)

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  after_action :set_anonymous_user_cookie

  def current_user
    Public::User.find_by(clerk_id: clerk.user.id) if clerk.user?
  end

  def current_anonymous_user
    @current_anonymous_user ||= AnonymousUserManager.current_anonymous_user(request)
  end

  private

  def set_anonymous_user_cookie
    return if clerk.user? rescue false
    return if current_anonymous_user.present?

    AnonymousUserManager.get_or_create_anonymous_user(request, response)
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  def internal_server_error
    render file: "#{Rails.root}/public/500.html", status: :internal_server_error, layout: false
  end
end
