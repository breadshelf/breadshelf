module Public
  module Entries
    class Create < ApplicationService
      def initialize(user:, book_title:, author_name: nil)
        @user = user
        @book_title = book_title
        @author_name = author_name
      end

      def call
        validate_title!
        book = Public::Books::FindOrCreate.call(@book_title, author: @author_name)
        Entry.create!(user: @user, book: book)
      end

      private

      def validate_title!
        raise ArgumentError, 'Book title cannot be blank' if @book_title.blank?
      end
    end
  end
end
