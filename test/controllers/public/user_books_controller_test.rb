require 'test_helper'

module Public
  class UserBooksControllerTest < ActionDispatch::IntegrationTest
    test 'redirects to /welcome when mvp disabled' do
      Flipper.disable(:mvp)

      clerk_sign_in(user_attrs: { id: users(:amy).clerk_id })

      get '/user_books'

      assert_response :redirect
      assert_redirected_to '/welcome'
    end

    test 'redirects to new when no active user_books' do
      Flipper.enable(:mvp)

      user = users(:amy)
      clerk_sign_in(user_attrs: { id: user.clerk_id })

      Public::UserBook.where(user_id: user.id).delete_all

      get '/user_books'

      assert_response :redirect
      assert_redirected_to new_user_book_path
    end

    test 'renders index when active user_books exist' do
      Flipper.enable(:mvp)

      user = users(:amy)
      clerk_sign_in(user_attrs: { id: user.clerk_id })

      book = Public::Book.create!(title: 'Active')
      Public::UserBook.create!(user: user, book: book, active: true)

      get '/user_books'

      assert_response :success
      # Use DOM assertions to verify list rendering instead of assigns
      assert_dom('h1', 'Your books')
      assert_dom('li.user-books__item', /Active/)
    end

    test 'renders index inside turbo frame when Turbo-Frame header present' do
      Flipper.enable(:mvp)

      user = users(:amy)
      clerk_sign_in(user_attrs: { id: user.clerk_id })

      book = Public::Book.create!(title: 'Active')
      Public::UserBook.create!(user: user, book: book, active: true)

      get '/user_books', headers: { 'Turbo-Frame' => 'landing-content' }

      assert_response :success
      assert_dom('turbo-frame#user_books_list')
    end
  end
end
