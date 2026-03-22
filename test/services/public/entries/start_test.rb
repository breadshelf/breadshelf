require 'test_helper'

class Public::Entries::StartTest < ActiveSupport::TestCase
  def test_sets_start_time_on_entry
    entry = entries(:one)
    result = Public::Entries::Start.call(entry_id: entry.id)

    assert_not_nil result.start_time
    assert_equal entry.id, result.id
  end

  def test_raises_error_when_entry_not_found
    assert_raises(ActiveRecord::RecordNotFound) do
      Public::Entries::Start.call(entry_id: 'nonexistent-id')
    end
  end
end
