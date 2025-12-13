require 'test_helper'

module Analytics
  class Events::PageViewTest < ActiveSupport::TestCase
    test 'creates a page_view event with the given path as subject' do
      path = '/home'

      Events::PageView.call(path)

      event = Analytics::Event.last
      assert_equal(event.event, Analytics::Event::EventName::PAGE_VIEW)
      assert_equal(event.subject, path)
    end

    test 'preserves the full path as subject' do
      paths = ['/home', '/books', '/settings', '/api/v1/users']

      paths.each do |path|
        Events::PageView.call(path)
      end

      recorded_paths = Analytics::Event.where(event: Analytics::Event::EventName::PAGE_VIEW)
                                       .pluck(:subject)
      assert_equal(recorded_paths, paths)
    end

    test 'inherits from Events::Create' do
      assert(Events::PageView < Events::Create)
    end

    test 'creates event with correct timestamp' do
      time_before = Time.current
      Events::PageView.call('/home')
      time_after = Time.current

      event = Analytics::Event.last
      assert(event.created_at >= time_before)
      assert(event.created_at <= time_after)
    end

    test 'handles paths with query parameters' do
      path = '/books?sort=title&filter=active'

      Events::PageView.call(path)

      event = Analytics::Event.last
      assert_equal(event.subject, path)
    end

    test 'can track multiple page views' do
      initial_count = Analytics::Event.where(event: Analytics::Event::EventName::PAGE_VIEW).count

      Events::PageView.call('/home')
      Events::PageView.call('/books')
      Events::PageView.call('/settings')

      final_count = Analytics::Event.where(event: Analytics::Event::EventName::PAGE_VIEW).count
      assert_equal(final_count, initial_count + 3)
    end
  end
end
