require 'test_helper'

class Public::Entries::CreateTest < ActiveSupport::TestCase
  def setup
    @user = users(:amy)
  end

  def test_creates_an_entry_with_valid_parameters
    result = Public::Entries::Create.call(user: @user, book_details: { book_title: 'The Great Gatsby' })

    assert result.persisted?
    assert_equal @user.id, result.user_id
    assert_equal 'the great gatsby', result.book.title
  end

  def test_finds_existing_book_instead_of_creating_duplicate
    book = books(:titan)

    result = Public::Entries::Create.call(user: @user, book_details: { book_title: book.title, author_name: book.author })

    assert_equal book.id, result.book_id
  end

  def test_creates_entry_with_author_name
    result = Public::Entries::Create.call(user: @user, book_details: { book_title: 'Test Book', author_name: 'Test Author' })

    assert result.persisted?
    assert_equal 'test author', result.book.author
  end

  def test_creates_entry_for_anonymous_user
    anon_user = Public::AnonymousUser.create!

    result = Public::Entries::Create.call(anonymous_user: anon_user, book_details: { book_title: 'Anonymous Book' })

    assert result.persisted?
    assert_equal anon_user.id, result.anonymous_user_id
    assert_nil result.user_id
    assert_equal 'anonymous book', result.book.title
  end

  def test_raises_error_when_title_is_blank
    assert_raises(ArgumentError) do
      Public::Entries::Create.call(user: @user, book_details: { book_title: '' })
    end
  end

  def test_raises_error_when_title_is_nil
    assert_raises(ArgumentError) do
      Public::Entries::Create.call(user: @user, book_details: { book_title: nil })
    end
  end
end
