require 'test_helper'

module Analytics
  class EventsControllerTest < ActionDispatch::IntegrationTest
    email = 'test@example.com'

    setup do
      ENV['ADMIN_EMAIL'] = email

      clerk_sign_in
    end

    class IndexTests < EventsControllerTest
      test 'displays events page' do
        get '/admin/events'

        assert_response :success
        assert_select 'h1', 'Events'
      end

      test 'displays total events count' do
        # Create some test events
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_UP, subject: 'user1@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: 'user1@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/home')

        get '/admin/events'

        assert_response :success
        assert_select 'h2', text: /Total Events: 3/
      end

      test 'displays sign up count' do
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_UP, subject: 'user1@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_UP, subject: 'user2@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: 'user1@example.com')

        get '/admin/events'

        assert_response :success
        assert_select 'h3', text: /Sign ups: 2/
      end

      test 'displays sign in count' do
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: 'user1@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: 'user2@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_UP, subject: 'user1@example.com')

        get '/admin/events'

        assert_response :success
        assert_select 'h3', text: /Sign ins: 2/
      end

      test 'displays page view counts by path' do
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/home')
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/home')
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/books')

        get '/admin/events'

        assert_response :success
        assert_select 'h3', text: 'Page Views:'
        assert_select 'ul li', text: /\/home - 2/
        assert_select 'ul li', text: /\/books - 1/
      end

      test 'displays daily active users (DAUs)' do
        # Create sign_in events for today
        Digest::SHA256.hexdigest('user1@example.com')
        Digest::SHA256.hexdigest('user2@example.com')

        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: Digest::SHA256.hexdigest('user1@example.com'), created_at: Time.current)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: Digest::SHA256.hexdigest('user2@example.com'), created_at: Time.current)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: Digest::SHA256.hexdigest('user1@example.com'), created_at: Time.current)

        get '/admin/events'

        assert_response :success
        assert_select 'h3', text: 'Daily Active Users (DAUs):'
        assert_select 'table'
        assert_select 'table thead tr th', text: 'Date'
        assert_select 'table thead tr th', text: 'Active Users'
      end

      test 'DAUs table shows correct data' do
        today = Time.current.to_date
        tomorrow = (Time.current + 1.day).to_date

        hash1 = Digest::SHA256.hexdigest('user1@example.com')
        hash2 = Digest::SHA256.hexdigest('user2@example.com')
        hash3 = Digest::SHA256.hexdigest('user3@example.com')

        # Create events for today: 2 unique users
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash1, created_at: today.to_time)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash1, created_at: today.to_time) # Same user again
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash2, created_at: today.to_time)

        # Create events for tomorrow: 1 unique user
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash3, created_at: tomorrow.to_time)

        get '/admin/events'

        assert_response :success
        # Check that the data is present in the response
        assert_match(/#{today}/, response.body)
        assert_match(/2/, response.body) # 2 unique users today
      end

      test 'DAUs are limited to last 2 weeks' do
        today = Time.current.to_date
        three_weeks_ago = (Time.current - 21.days).to_date

        hash1 = Digest::SHA256.hexdigest('user1@example.com')
        hash2 = Digest::SHA256.hexdigest('user2@example.com')

        # Create event from 3 weeks ago (should not appear)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash1, created_at: three_weeks_ago.to_time)

        # Create event from today (should appear)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash2, created_at: today.to_time)

        get '/admin/events'

        assert_response :success
        # Should have DAU data for today but not 3 weeks ago
        assert_match(/#{today}/, response.body)
        assert_no_match(/#{three_weeks_ago}/, response.body)
      end

      test 'handles empty analytics data gracefully' do
        # Delete any existing events
        Analytics::Event.delete_all

        get '/admin/events'

        assert_response :success
        assert_select 'h2', text: /Total Events: 0/
        assert_select 'h3', text: /Sign ups: 0/
        assert_select 'h3', text: /Sign ins: 0/
      end

      test 'page renders even with mixed event types' do
        # Create a mix of all event types
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_UP, subject: 'user@example.com')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: Digest::SHA256.hexdigest('user@example.com'), created_at: Time.current)
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/home')
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/books')

        get '/admin/events'

        assert_response :success
        assert_select 'h1', 'Events'
      end

      test 'requires admin authentication' do
        clerk_sign_in(user_attrs: { email_addresses: [stub(email_address: 'regular@example.com')] })

        get '/admin/events'

        assert_response :not_found
      end

      test 'calculate_daus returns data in descending date order' do
        today = Time.current.to_date
        yesterday = (Time.current - 1.day).to_date
        two_days_ago = (Time.current - 2.days).to_date

        hash1 = Digest::SHA256.hexdigest('user1@example.com')
        hash2 = Digest::SHA256.hexdigest('user2@example.com')
        hash3 = Digest::SHA256.hexdigest('user3@example.com')

        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash1, created_at: two_days_ago.to_time)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash2, created_at: yesterday.to_time)
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: hash3, created_at: today.to_time)

        get '/admin/events'

        assert_response :success
        # Check order - today should appear before yesterday, and yesterday before two_days_ago
        today_pos = response.body.index(today.to_s)
        yesterday_pos = response.body.index(yesterday.to_s)
        two_days_ago_pos = response.body.index(two_days_ago.to_s)

        assert(today_pos < yesterday_pos, 'Today should appear before yesterday')
        assert(yesterday_pos < two_days_ago_pos, 'Yesterday should appear before two days ago')
      end

      test 'page view counts only count PAGE_VIEW events' do
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/home')
        Analytics::Event.create!(event: Analytics::Event::EventName::SIGN_IN, subject: '/home')
        Analytics::Event.create!(event: Analytics::Event::EventName::PAGE_VIEW, subject: '/books')

        get '/admin/events'

        assert_response :success
        # Should only count PAGE_VIEW events, not SIGN_IN
        assert_select 'ul li', text: /\/home - 1/
        assert_select 'ul li', text: /\/books - 1/
      end
    end
  end
end
