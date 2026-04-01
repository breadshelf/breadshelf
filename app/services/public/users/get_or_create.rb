module Public
  module Users
    class GetOrCreate < ApplicationService
      COOKIE_DURATION = 400.days

      def initialize(request, response)
        @request = request
        @response = response
      end

      def call
        cookie_id = @request.cookies[Public::User::Constants::ANONYMOUS_USER_COOKIE]

        if cookie_id.present?
          user = Public::User.find_by(id: cookie_id, anonymous: true)
          return user if user.present?
        end

        new_user = Public::User.create!(anonymous: true)
        set_cookie(new_user.id)
        new_user
      end

      private

      def set_cookie(user_id)
        @response.set_cookie(
          Public::User::Constants::ANONYMOUS_USER_COOKIE,
          value: user_id,
          expires: COOKIE_DURATION.from_now,
          secure: Rails.env.production?,
          http_only: true,
          same_site: :lax
        )
      end
    end
  end
end
