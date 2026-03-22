module Public
  module Entries
    class Create < ApplicationService
      def initialize(book_details:, user:)
        @user = user
        @book_title = book_details[:book_title]
        @author_name = book_details[:author_name]
      end

      def call
        validate_title!
        book = Public::Books::FindOrCreate.call(@book_title, author: @author_name)
        user_book = @user.user_books.find_or_create_by!(book: book)
        Entry.create!(user_book: user_book)
      end

      private

      def validate_title!
        raise ArgumentError, 'Book title cannot be blank' if @book_title.blank?
      end
    end
  end
end
