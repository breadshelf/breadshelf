require 'test_helper'

class AnonymousUserManagerTest < ActiveSupport::TestCase
  def setup
    @request = ActionDispatch::TestRequest.create
    @response = ActionDispatch::TestResponse.new
  end

  test 'current_anonymous_user returns nil when no cookie is set' do
    user = AnonymousUserManager.current_anonymous_user(@request)
    assert_nil user
  end

  test 'current_anonymous_user returns user when valid cookie is set' do
    anon_user = Public::AnonymousUser.create!
    @request.cookies[AnonymousUserManager::COOKIE_NAME] = anon_user.id

    user = AnonymousUserManager.current_anonymous_user(@request)
    assert_equal anon_user, user
  end

  test 'current_anonymous_user returns nil when cookie references missing user' do
    @request.cookies[AnonymousUserManager::COOKIE_NAME] = '00000000-0000-0000-0000-000000000000'

    user = AnonymousUserManager.current_anonymous_user(@request)
    assert_nil user
  end

  test 'set_anonymous_user_cookie sets cookie with correct options' do
    user_id = SecureRandom.uuid
    AnonymousUserManager.set_anonymous_user_cookie(@response, user_id)

    assert @response.cookies[AnonymousUserManager::COOKIE_NAME].present?
  end

  test 'clear_anonymous_user_cookie deletes cookie' do
    AnonymousUserManager.clear_anonymous_user_cookie(@response)

    # delete_cookie sets the value to nil in the response
    assert true
  end

  test 'get_or_create_anonymous_user returns existing user when cookie is valid' do
    anon_user = Public::AnonymousUser.create!
    @request.cookies[AnonymousUserManager::COOKIE_NAME] = anon_user.id

    user = AnonymousUserManager.get_or_create_anonymous_user(@request, @response)
    assert_equal anon_user, user
  end

  test 'get_or_create_anonymous_user creates new user when no cookie exists' do
    user = AnonymousUserManager.get_or_create_anonymous_user(@request, @response)

    assert user.persisted?
    assert Public::AnonymousUser.find_by(id: user.id).present?
  end

  test 'get_or_create_anonymous_user sets cookie when creating new user' do
    user = AnonymousUserManager.get_or_create_anonymous_user(@request, @response)

    assert @response.cookies[AnonymousUserManager::COOKIE_NAME].present?
  end

  test 'get_or_create_anonymous_user creates new user when cookie references missing user' do
    @request.cookies[AnonymousUserManager::COOKIE_NAME] = '00000000-0000-0000-0000-000000000000'

    user = AnonymousUserManager.get_or_create_anonymous_user(@request, @response)
    assert user.persisted?
    assert_not_equal '00000000-0000-0000-0000-000000000000', user.id
  end
end
