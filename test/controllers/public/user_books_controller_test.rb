require 'test_helper'
require 'mocha/minitest'

module Public
  class UserBooksControllerTest < ActionDispatch::IntegrationTest
    setup do
      Flipper.enable(:mvp)
    end

    class IndexTests < UserBooksControllerTest
      test 'redirects to /welcome when mvp disabled' do
        Flipper.disable(:mvp)

        clerk_sign_in(user_attrs: { id: users(:amy).clerk_id })

        get user_books_path

        assert_response :redirect
        assert_redirected_to '/welcome'
      end

      test 'redirects to new when user is nil' do
        clerk_sign_out

        get user_books_path

        assert_redirected_to new_user_book_path
      end

      test 'redirects to new when no active user_books' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        Public::UserBook.where(user_id: user.id).update_all(active: false)

        get user_books_path

        assert_redirected_to new_user_book_path
      end

      test 'renders index when active user_books exist' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        book = Public::Book.create!(title: 'Active')
        Public::UserBook.create!(user: user, book: book, active: true)

        get user_books_path

        assert_response :success
        assert_dom('h1', 'Your books')
        assert_dom('li.user-books__item', /Active/)
      end

      test 'renders index inside turbo frame when Turbo-Frame header present' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        book = Public::Book.create!(title: 'Active')
        Public::UserBook.create!(user: user, book: book, active: true)

        get user_books_path, headers: { 'Turbo-Frame' => 'landing-content' }

        assert_response :success
        assert_dom('h1', 'Your books')
      end
    end

    class NewTests < UserBooksControllerTest
      test 'renders new page' do
        get new_user_book_path

        assert_response :ok
      end

      test 'redirects to /welcome when MVP disabled' do
        Flipper.disable(:mvp)

        get new_user_book_path

        assert_redirected_to '/welcome'
      end
    end

    class CreateTests < UserBooksControllerTest
      test 'redirects to books index with notice on success' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        post user_books_path, params: { book: { title: 'New Book', author: 'Some Author' } }

        assert_redirected_to user_books_path
        assert_equal 'Book added', flash[:notice][:message]
      end

      test 'renders new with unprocessable_entity when create fails' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        unpersisted = Public::UserBook.new
        Public::UserBooks::Create.stubs(:call).returns(unpersisted)

        post user_books_path, params: { book: { title: 'Bad Book' } }

        assert_response :unprocessable_entity
      end

      test 'redirects to /welcome when MVP disabled' do
        Flipper.disable(:mvp)

        post user_books_path, params: { book: { title: 'Test' } }

        assert_redirected_to '/welcome'
      end
    end
  end
end
