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

    class ReadTests < EntriesControllerTest
      test 'renders read page for a valid entry' do
        entry = entries(:one)
        entry.update!(end_time: nil)

        get read_path, params: { entry_id: entry.id }

        assert_response :ok
      end

      test 'returns 404 when entry is not found' do
        get read_path, params: { entry_id: 'nonexistent-id' }

        assert_response :not_found
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        get read_path, params: { entry_id: entries(:one).id }

        assert_response :not_found
      end
    end

    class StartTests < EntriesControllerTest
      test 'sets start time on the entry and returns ok' do
        entry = entries(:one)

        patch start_entry_path(entry)

        assert_response :ok
        assert_not_nil entry.reload.start_time
      end

      test 'returns 404 when entry is not found' do
        patch start_entry_path('nonexistent-id')

        assert_response :not_found
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        patch start_entry_path(entries(:one))

        assert_response :not_found
      end
    end

    class EndTests < EntriesControllerTest
      test 'sets end_time and redirects to new note page' do
        entry = entries(:one)

        patch end_entry_path(entry)

        assert_redirected_to new_note_path(entry_id: entry.id)
        assert_not_nil entry.reload.end_time
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        patch end_entry_path(entries(:one))

        assert_response :not_found
      end
    end

    class FinishTests < EntriesControllerTest
      test 'calculates crumbs and redirects to entry show' do
        entry = entries(:one)

        patch finish_entry_path(entry)

        assert_redirected_to entry_path(entry)
        assert entry.reload.crumbs >= 0
      end

      test 'saves finished_book true when param is passed' do
        entry = entries(:one)

        patch finish_entry_path(entry),
          params: { finished_book: true },
          as: :json

        assert entry.reload.finished_book
      end

      test 'deactivates user_book when finished_book is true' do
        entry = entries(:one)

        patch finish_entry_path(entry),
          params: { finished_book: true },
          as: :json

        assert_not entry.user_book.reload.active
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        patch finish_entry_path(entries(:one))

        assert_response :not_found
      end
    end

    class ShowTests < EntriesControllerTest
      test 'renders entry show page' do
        get entry_path(entries(:one))

        assert_response :ok
      end

      test 'returns 404 when entry not found' do
        get entry_path('nonexistent-id')

        assert_response :not_found
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        get entry_path(entries(:one))

        assert_response :not_found
      end
    end

    class CreateTests < EntriesControllerTest
      test 'redirects to read page when authenticated and entry is created' do
        user = users(:amy)
        user_book = user_books(:amy_titan)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        post entries_path, params: { user_book_id: user_book.id }

        entry = Public::Entry.where(user_book: user_book).order(created_at: :desc).first
        assert_redirected_to read_path(entry_id: entry.id)
      end

      test 'raises error when user_book_id is missing' do
        user = users(:amy)
        clerk_sign_in(user_attrs: { id: user.clerk_id })

        assert_raises(ArgumentError) do
          post entries_path
        end
      end

      test 'returns 404 when MVP feature is disabled' do
        Flipper.disable(:mvp)

        post entries_path, params: { user_book_id: user_books(:amy_titan).id }

        assert_response :not_found
      end
    end
  end
end
