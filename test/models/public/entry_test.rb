require 'test_helper'

module Public
  class EntryTest < ActiveSupport::TestCase
    test 'entry must belong to a user' do
      book = Book.create!(title: 'Test Book')
      entry = Entry.new(book: book)

      assert_not entry.valid?
    end

    test 'entry with user is valid' do
      book = Book.create!(title: 'Test Book')
      user = User.create!(email: 'test@example.com', clerk_id: 'clerk_1')
      entry = Entry.create!(book: book, user: user)

      assert entry.valid?
      assert entry.persisted?
    end

    test 'entry with anonymous user is valid' do
      book = Book.create!(title: 'Test Book')
      user = User.create!(anonymous: true)
      entry = Entry.create!(book: book, user: user)

      assert entry.valid?
      assert entry.persisted?
    end

    test 'owner returns user' do
      book = Book.create!(title: 'Test Book')
      user = User.create!(email: 'test@example.com', clerk_id: 'clerk_1')
      entry = Entry.create!(book: book, user: user)

      assert_equal user, entry.owner
    end
  end
end
