require 'test_helper'
require 'mocha/minitest'

module Public
  class EntriesControllerTest < ActionDispatch::IntegrationTest
    class NewTests < EntriesControllerTest
      test 'displays the new entry form when not signed in' do
        clerk_sign_out

        get new_entry_path

        assert_response :success
        assert_dom 'h1', 'What are you reading?'
      end

      test 'displays the new entry form when signed in' do
        clerk_sign_in(user_attrs: { id: 'user_1234' })

        get new_entry_path

        assert_response :success
        assert_dom 'h1', 'What are you reading?'
      end
    end

    class CreateTests < EntriesControllerTest
      test 'redirects to success page when authenticated and entry is created' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        entry = user.entries.build
        entry.book = books(:titan)
        entry.save!

        post entries_path, params: { entry: { book_title: 'Titan' } }

        assert_response :redirect
      end

      test 'redirects to sign in when not authenticated' do
        clerk_sign_out

        post entries_path, params: { entry: { book_title: 'Test Book' } }

        assert_response :redirect
        assert_redirected_to new_entry_path
      end
    end
  end
end
