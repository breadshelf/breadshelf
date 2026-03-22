require 'test_helper'
require 'mocha/minitest'

module Public
  class EntriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      Flipper.enable(:mvp)
    end

    class NewTests < EntriesControllerTest
      test 'redirects to new user book path' do
        get new_entry_path

        assert_redirected_to new_user_book_path
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        get new_entry_path

        assert_response :not_found
      end
    end

    class CreateTests < EntriesControllerTest
      test 'redirects to success page when authenticated and entry is created' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        post entries_path, params: { entry: { book_title: 'test book' } }

        book = Public::Book.find_by(title: 'test book')
        assert book.present?

        user_book = Public::UserBook.find_by(user: user, book: book)
        entry = Public::Entry.find_by(user_book: user_book)
        assert_redirected_to entry_path(entry)
      end

      test 'redirects to sign in when not authenticated' do
        clerk_sign_out

        anonymous_user = Public::User.create!(anonymous: true)

        post entries_path,
          headers: { 'HTTP_COOKIE' => "_anonymous_user_id=#{anonymous_user.id}" },
          params: { entry: { book_title: 'Test Book' } }

        assert_response :redirect

        book = Public::Book.find_by(title: 'test book')
        assert book.present?

        user_book = Public::UserBook.find_by(user: anonymous_user)
        entry = Public::Entry.find_by(user_book: user_book)
        assert_redirected_to entry_path(entry)
      end

      test 'stores author when provided' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        post entries_path, params: { entry: { book_title: 'New Book', author_name: 'Test Author' } }

        assert_response :redirect
        book = Public::Book.find_by(title: 'new book')
        assert_equal 'test author', book.author
      end

      test 'creates entry without author when author field is empty' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        post entries_path, params: { entry: { book_title: 'Another Book', author_name: '' } }

        assert_response :redirect
        book = Public::Book.find_by(title: 'another book')
        assert_nil book.author
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        post entries_path, params: { entry: { book_title: 'Test Book' } }

        assert_response :not_found
      end
    end
  end
end
