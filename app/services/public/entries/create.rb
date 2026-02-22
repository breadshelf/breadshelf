module Public
  module Entries
    class Create < ApplicationService
      def initialize(user:, book_title:)
        @user = user
        @book_title = book_title
      end

      def call
        validate_title!
        book = Public::Books::FindOrCreate.call(@book_title)
        Entry.create!(user: @user, book: book)
      end

      private

      def validate_title!
        raise ArgumentError, 'Book title cannot be blank' if @book_title.blank?
      end
    end
  end
end
