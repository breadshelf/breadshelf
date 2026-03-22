module Public
  module Entries
    class Start < ApplicationService
      def initialize(entry_id:)
        @entry_id = entry_id
      end

      def call
        entry = Entry.find(@entry_id)
        entry.update!(start_time: Time.current)
        entry
      end
    end
  end
end
