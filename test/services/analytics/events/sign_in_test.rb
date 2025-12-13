require 'test_helper'

module Analytics
  class Events::SignInTest < ActiveSupport::TestCase
    test 'creates a sign_in event with hashed subject' do
      email = 'user@example.com'
      hashed_email = Digest::SHA256.hexdigest(email)

      Events::SignIn.call(email)

      event = Analytics::Event.last
      assert_equal(event.event, Analytics::Event::EventName::SIGN_IN)
      assert_equal(event.subject, hashed_email)
    end

    test 'hashes different emails to different values' do
      email1 = 'user1@example.com'
      email2 = 'user2@example.com'

      Events::SignIn.call(email1)
      event1 = Analytics::Event.last

      Events::SignIn.call(email2)
      event2 = Analytics::Event.last

      assert_not_equal(event1.subject, event2.subject)
    end

    test 'hashes the same email consistently' do
      email = 'user@example.com'
      hashed_email = Digest::SHA256.hexdigest(email)

      Events::SignIn.call(email)
      event1 = Analytics::Event.last
      subject1 = event1.subject

      Events::SignIn.call(email)
      event2 = Analytics::Event.last
      subject2 = event2.subject

      assert_equal(subject1, subject2)
      assert_equal(subject1, hashed_email)
    end

    test 'inherits from Events::Create' do
      assert(Events::SignIn < Events::Create)
    end

    test 'creates event with correct timestamp' do
      time_before = Time.current
      Events::SignIn.call('user@example.com')
      time_after = Time.current

      event = Analytics::Event.last
      assert(event.created_at >= time_before)
      assert(event.created_at <= time_after)
    end

    test 'does not create event when subject is nil or empty' do
      initial_count = Analytics::Event.where(event: Analytics::Event::EventName::SIGN_IN).count

      Events::SignIn.call(nil)
      Events::SignIn.call('')

      final_count = Analytics::Event.where(event: Analytics::Event::EventName::SIGN_IN).count
      assert_equal(initial_count, final_count)
    end
  end
end
