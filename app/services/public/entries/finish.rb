module Public
  module Entries
    class Finish < ApplicationService
      def initialize(entry_id:, finished_book: false)
        @entry_id = entry_id
        @finished_book = finished_book
      end

      def call
        entry = Entry.find(@entry_id)
        entry.update!(crumbs: reading_crumbs(entry) + note_crumbs(entry), finished_book: @finished_book)
        entry.user_book.update!(active: false) if @finished_book
        entry
      end

      private

      def reading_crumbs(entry)
        return 0 unless entry.start_time && entry.end_time

        (entry.end_time - entry.start_time).to_i / 60 / 5
      end

      def note_crumbs(entry)
        note = entry.notes.last
        return 0 unless note

        [note.content.length / 100, 10].min
      end
    end
  end
end
