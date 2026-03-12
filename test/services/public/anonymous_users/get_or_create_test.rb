require 'test_helper'

module Public
  module AnonymousUsers
    class GetOrCreateTest < ActiveSupport::TestCase
      def setup
        @request = ActionDispatch::TestRequest.create
        @response = ActionDispatch::TestResponse.new
      end

      test 'call returns existing user when cookie is valid' do
        anon_user = Public::User.create!(anonymous: true)
        @request.cookies[GetOrCreate::COOKIE_NAME] = anon_user.id

        user = GetOrCreate.call(@request, @response)
        assert_equal anon_user, user
      end

      test 'call creates new user when no cookie exists' do
        user = GetOrCreate.call(@request, @response)

        assert user.persisted?
        assert user.anonymous?
        assert Public::User.find_by(id: user.id, anonymous: true).present?
      end

      test 'call sets cookie when creating new user' do
        GetOrCreate.call(@request, @response)

        assert @response.cookies[GetOrCreate::COOKIE_NAME].present?
      end

      test 'call creates new user when cookie references missing user' do
        @request.cookies[GetOrCreate::COOKIE_NAME] = '00000000-0000-0000-0000-000000000000'

        user = GetOrCreate.call(@request, @response)
        assert user.persisted?
        assert_not_equal '00000000-0000-0000-0000-000000000000', user.id
        assert user.anonymous?
      end
    end
  end
end
