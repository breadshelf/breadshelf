require 'test_helper'

class Public::Notes::CreateTest < ActiveSupport::TestCase
  test 'creates a note for an entry' do
    entry = entries(:one)

    result = Public::Notes::Create.call(entry_id: entry.id, content: 'Interesting chapter')

    assert result.persisted?
    assert_equal entry.id, result.entry_id
    assert_equal 'Interesting chapter', result.content
  end

  test 'raises error when content is blank' do
    assert_raises(ArgumentError) do
      Public::Notes::Create.call(entry_id: entries(:one).id, content: '')
    end
  end

  test 'raises error when content is nil' do
    assert_raises(ArgumentError) do
      Public::Notes::Create.call(entry_id: entries(:one).id, content: nil)
    end
  end

  test 'raises error when entry not found' do
    assert_raises(ActiveRecord::RecordNotFound) do
      Public::Notes::Create.call(entry_id: 'nonexistent-id', content: 'test')
    end
  end
end
