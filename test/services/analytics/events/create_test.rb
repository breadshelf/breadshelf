require 'test_helper'

module Analytics
  class Events::CreateTest < ActiveSupport::TestCase
    test 'creates an event with the given event type and subject' do
      event_type = 'test_event'
      subject = 'test_subject'

      Events::Create.call(event_type, subject)

      event = Analytics::Event.last
      assert_equal(event.event, event_type)
      assert_equal(event.subject, subject)
    end

    test 'creates an event with nil subject' do
      event_type = 'test_event'

      Events::Create.call(event_type, nil)

      event = Analytics::Event.last
      assert_equal(event.event, event_type)
      assert_nil(event.subject)
    end

    test 'gracefully handles errors during event creation' do
      # Mock Event.create! to raise an error
      Analytics::Event.expects(:create!).raises(StandardError, 'Database error')

      # Should not raise an error due to rescue clause
      assert_nothing_raised do
        Events::Create.call('test_event', 'test_subject')
      end
    end

    test 'records multiple events' do
      initial_count = Analytics::Event.count

      Events::Create.call('event_1', 'subject_1')
      Events::Create.call('event_2', 'subject_2')
      Events::Create.call('event_3', 'subject_3')

      assert_equal(Analytics::Event.count, initial_count + 3)
    end
  end
end
