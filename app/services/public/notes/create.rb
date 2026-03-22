module Public
  module Notes
    class Create < ApplicationService
      def initialize(entry_id:, content:)
        @entry_id = entry_id
        @content = content
      end

      def call
        raise(ArgumentError, 'Content cannot be blank') if @content.blank?

        entry = Entry.find(@entry_id)
        entry.notes.create!(content: @content)
      end
    end
  end
end
