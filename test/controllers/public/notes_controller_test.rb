require 'test_helper'

module Public
  class NotesControllerTest < ActionDispatch::IntegrationTest
    class ShowTests < NotesControllerTest
      test 'renders note page' do
        get note_path(notes(:one))

        assert_response :ok
      end

      test 'returns 404 when note not found' do
        get note_path('nonexistent-id')

        assert_response :not_found
      end
    end

    class NewTests < NotesControllerTest
      test 'renders new note page for a valid entry' do
        get new_note_path(entry_id: entries(:one).id)

        assert_response :ok
      end

      test 'returns 404 when entry not found' do
        get new_note_path(entry_id: 'nonexistent-id')

        assert_response :not_found
      end
    end

    class CreateTests < NotesControllerTest
      test 'creates note and redirects to note show' do
        entry = entries(:one)

        post notes_path, params: { entry_id: entry.id, note: { content: 'Great session' } }

        note = Public::Note.where(entry: entry).order(created_at: :desc).first
        assert_redirected_to note_path(note)
        assert_equal 'Great session', note.content
      end

      test 'returns 404 when entry not found' do
        post notes_path, params: { entry_id: 'nonexistent-id', note: { content: 'test' } }

        assert_response :not_found
      end
    end
  end
end
