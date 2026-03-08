require 'test_helper'

module Public
  class EntryTest < ActiveSupport::TestCase
    test 'entry must belong to either user or anonymous user' do
      book = Book.create!(title: 'Test Book')
      entry = Entry.new(book: book)

      assert_not entry.valid?
      assert entry.errors[:base].any? { |msg| msg.include?('must belong to either') }
    end

    test 'entry cannot belong to both user and anonymous user' do
      book = Book.create!(title: 'Test Book')
      user = User.create!(email: 'test@example.com')
      anon_user = AnonymousUser.create!

      entry = Entry.new(book: book, user: user, anonymous_user: anon_user)

      assert_not entry.valid?
      assert entry.errors[:base].any? { |msg| msg.include?('cannot belong to both') }
    end

    test 'entry with user is valid' do
      book = Book.create!(title: 'Test Book')
      user = User.create!(email: 'test@example.com')
      entry = Entry.create!(book: book, user: user)

      assert entry.valid?
      assert entry.persisted?
    end

    test 'entry with anonymous user is valid' do
      book = Book.create!(title: 'Test Book')
      anon_user = AnonymousUser.create!
      entry = Entry.create!(book: book, anonymous_user: anon_user)

      assert entry.valid?
      assert entry.persisted?
    end

    test 'owner returns user when user_id is set' do
      book = Book.create!(title: 'Test Book')
      user = User.create!(email: 'test@example.com')
      entry = Entry.create!(book: book, user: user)

      assert_equal user, entry.owner
    end

    test 'owner returns anonymous user when anonymous_user_id is set' do
      book = Book.create!(title: 'Test Book')
      anon_user = AnonymousUser.create!
      entry = Entry.create!(book: book, anonymous_user: anon_user)

      assert_equal anon_user, entry.owner
    end
  end
end
