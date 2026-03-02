module Public
  module AnonymousUsers
    class GetOrCreate < ApplicationService
      COOKIE_NAME = '_anonymous_user_id'
      COOKIE_DURATION = 400.days

      def initialize(request, response)
        @request = request
        @response = response
      end

      def call
        cookie_id = @request.cookies[COOKIE_NAME]

        if cookie_id.present?
          user = Public::AnonymousUser.find_by(id: cookie_id)
          return user if user.present?
        end

        new_user = Public::AnonymousUser.create!
        set_cookie(new_user.id)
        new_user
      end

      private

      def set_cookie(user_id)
        @response.set_cookie(
          COOKIE_NAME,
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
