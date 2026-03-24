require 'test_helper'

class Public::Entries::FinishTest < ActiveSupport::TestCase
  test 'calculates reading crumbs from session duration' do
    entry = entries(:one) # 6 minutes = 1 reading crumb

    result = Public::Entries::Finish.call(entry_id: entry.id)

    assert_equal 1, result.crumbs
  end

  test 'calculates note crumbs when note has 100+ characters' do
    entry = entries(:two) # 21 min = 4 reading crumbs
    entry.notes.first.update!(content: 'a' * 150) # 150 chars = 1 note crumb

    result = Public::Entries::Finish.call(entry_id: entry.id)

    assert_equal 5, result.crumbs
  end

  test 'caps note crumbs at 10' do
    entry = entries(:two) # 4 reading crumbs
    entry.notes.first.update!(content: 'a' * 1100) # 1100 chars = 11, capped at 10

    result = Public::Entries::Finish.call(entry_id: entry.id)

    assert_equal 14, result.crumbs
  end

  test 'returns 0 note crumbs when no note exists' do
    entry = entries(:one)
    entry.notes.destroy_all

    result = Public::Entries::Finish.call(entry_id: entry.id)

    assert_equal 1, result.crumbs
  end

  test 'returns 0 crumbs when times are nil' do
    entry = entries(:one)
    entry.update!(start_time: nil, end_time: nil)
    entry.notes.destroy_all

    result = Public::Entries::Finish.call(entry_id: entry.id)

    assert_equal 0, result.crumbs
  end

  test 'raises when entry not found' do
    assert_raises(ActiveRecord::RecordNotFound) do
      Public::Entries::Finish.call(entry_id: 'nonexistent-id')
    end
  end

  test 'sets finished_book to true on entry when passed' do
    entry = entries(:one)

    result = Public::Entries::Finish.call(entry_id: entry.id, finished_book: true)

    assert result.finished_book
  end

  test 'finished_book defaults to false' do
    entry = entries(:one)

    result = Public::Entries::Finish.call(entry_id: entry.id)

    assert_not result.finished_book
  end

  test 'sets user_book active to false when finished_book is true' do
    entry = entries(:one)

    Public::Entries::Finish.call(entry_id: entry.id, finished_book: true)

    assert_not entry.user_book.reload.active
  end

  test 'does not change user_book active when finished_book is false' do
    entry = entries(:one)

    Public::Entries::Finish.call(entry_id: entry.id, finished_book: false)

    assert entry.user_book.reload.active
  end
end
