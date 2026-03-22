require 'test_helper'

module Public
  class EntryTest < ActiveSupport::TestCase
    test 'entry must belong to a user_book' do
      entry = Entry.new

      assert_not entry.valid?
    end

    test 'entry with user_book is valid' do
      user = User.create!(email: 'test@example.com', clerk_id: 'clerk_1')
      book = Book.create!(title: 'Test Book')
      user_book = UserBook.create!(user: user, book: book)
      entry = Entry.create!(user_book: user_book)

      assert entry.valid?
      assert entry.persisted?
    end

    test 'entry with anonymous user_book is valid' do
      user = User.create!(anonymous: true)
      book = Book.create!(title: 'Test Book')
      user_book = UserBook.create!(user: user, book: book)
      entry = Entry.create!(user_book: user_book)

      assert entry.valid?
      assert entry.persisted?
    end

    test 'owner returns user' do
      user = User.create!(email: 'test@example.com', clerk_id: 'clerk_1')
      book = Book.create!(title: 'Test Book')
      user_book = UserBook.create!(user: user, book: book)
      entry = Entry.create!(user_book: user_book)

      assert_equal user, entry.owner
    end
  end
end
