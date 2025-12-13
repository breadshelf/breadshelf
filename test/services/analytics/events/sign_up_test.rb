require 'test_helper'

module Analytics
  class Events::SignUpTest < ActiveSupport::TestCase
    test 'creates a sign_up event with hashed subject' do
      email = 'user@example.com'
      hashed_email = Digest::SHA256.hexdigest(email)

      Events::SignUp.call(email)

      event = Analytics::Event.last
      assert_equal(event.event, Analytics::Event::EventName::SIGN_UP)
      assert_equal(event.subject, hashed_email)
    end

    test 'hashes different emails to different values' do
      email1 = 'user1@example.com'
      email2 = 'user2@example.com'

      Events::SignUp.call(email1)
      event1 = Analytics::Event.last

      Events::SignUp.call(email2)
      event2 = Analytics::Event.last

      assert_not_equal(event1.subject, event2.subject)
    end

    test 'hashes the same email consistently' do
      email = 'user@example.com'
      hashed_email = Digest::SHA256.hexdigest(email)

      Events::SignUp.call(email)
      event1 = Analytics::Event.last
      subject1 = event1.subject

      Events::SignUp.call(email)
      event2 = Analytics::Event.last
      subject2 = event2.subject

      assert_equal(subject1, subject2)
      assert_equal(subject1, hashed_email)
    end

    test 'inherits from Events::Create' do
      assert(Events::SignUp < Events::Create)
    end

    test 'creates event with correct timestamp' do
      time_before = Time.current
      Events::SignUp.call('user@example.com')
      time_after = Time.current

      event = Analytics::Event.last
      assert(event.created_at >= time_before)
      assert(event.created_at <= time_after)
    end
  end
end
