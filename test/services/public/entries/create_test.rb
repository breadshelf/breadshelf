require 'test_helper'

class Public::Entries::CreateTest < ActiveSupport::TestCase
  def setup
    @user = users(:amy)
    @user_book = user_books(:amy_titan)
  end

  def test_creates_an_entry_for_a_user_book
    result = Public::Entries::Create.call(user: @user, user_book_id: @user_book.id)

    assert result.persisted?
    assert_equal @user_book.id, result.user_book_id
  end

  def test_raises_error_when_user_book_id_is_missing
    assert_raises(ArgumentError) do
      Public::Entries::Create.call(user: @user, user_book_id: nil)
    end
  end

  def test_raises_error_when_user_book_belongs_to_another_user
    other_user_book = user_books(:noah_thinking_fast_and_slow)

    assert_raises(ActiveRecord::RecordNotFound) do
      Public::Entries::Create.call(user: @user, user_book_id: other_user_book.id)
    end
  end
end
