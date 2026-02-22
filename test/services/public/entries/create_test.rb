require 'test_helper'

class Public::Entries::CreateTest < ActiveSupport::TestCase
  def setup
    @user = users(:amy)
  end

  def test_creates_an_entry_with_valid_parameters
    result = Public::Entries::Create.call(user: @user, book_title: 'The Great Gatsby')
    
    assert result.persisted?
    assert_equal @user.id, result.user_id
    assert_equal 'The Great Gatsby', result.book.title
  end

  def test_finds_existing_book_instead_of_creating_duplicate
    book = books(:titan)
    
    result = Public::Entries::Create.call(user: @user, book_title: book.title)
    
    assert_equal book.id, result.book_id
  end

  def test_raises_error_when_title_is_blank
    assert_raises(ArgumentError) do
      Public::Entries::Create.call(user: @user, book_title: '')
    end
  end

  def test_raises_error_when_title_is_nil
    assert_raises(ArgumentError) do
      Public::Entries::Create.call(user: @user, book_title: nil)
    end
  end
end
