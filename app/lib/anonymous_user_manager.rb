class AnonymousUserManager
  COOKIE_NAME = '_anonymous_user_id'
  COOKIE_DURATION = 1.year

  def self.current_anonymous_user(request)
    cookie_id = request.cookies[COOKIE_NAME]
    if cookie_id.present?
      Public::AnonymousUser.find_by(id: cookie_id)
    end
  end

  def self.set_anonymous_user_cookie(response, user_id)
    response.set_cookie(
      COOKIE_NAME,
      value: user_id,
      expires: COOKIE_DURATION.from_now,
      secure: Rails.env.production?,
      http_only: true,
      same_site: :lax
    )
  end

  def self.clear_anonymous_user_cookie(response)
    response.delete_cookie(COOKIE_NAME)
  end

  def self.get_or_create_anonymous_user(request, response)
    cookie_id = request.cookies[COOKIE_NAME]

    if cookie_id.present?
      user = Public::AnonymousUser.find_by(id: cookie_id)
      return user if user.present?
    end

    new_user = Public::AnonymousUser.create!
    set_anonymous_user_cookie(response, new_user.id)
    new_user
  end
end
