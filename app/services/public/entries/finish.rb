module Public
  module Entries
    class Finish < ApplicationService
      def initialize(entry_id:)
        @entry_id = entry_id
      end

      def call
        entry = Entry.find(@entry_id)
        reading = reading_crumbs(entry)
        note = note_crumbs(entry)
        entry.update!(crumbs: reading + note_crumbs(entry))
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
