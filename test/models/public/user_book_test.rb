require 'test_helper'

module Public
  class UserBookTest < ActiveSupport::TestCase
    test 'associations and default active' do
      user = Public::User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com', clerk_id: 'test-clerk-id')
      book = Public::Book.create!(title: 'Sample Book')
      ub = Public::UserBook.create!(user: user, book: book)

      assert ub.active, 'user_book should be active by default'
      assert_includes user.books, book
      assert_includes book.users, user
    end
  end
end
