module Public
  module Entries
    class Create < ApplicationService
      def initialize(book_details:, user: nil, anonymous_user: nil)
        @user = user
        @anonymous_user = anonymous_user
        @book_title = book_details[:book_title]
        @author_name = book_details[:author_name]
      end

      def call
        validate_title!
        book = Public::Books::FindOrCreate.call(@book_title, author: @author_name)
        Entry.create!(user: @user, anonymous_user: @user.present? ? nil : @anonymous_user, book: book)
      end

      private

      def validate_title!
        raise ArgumentError, 'Book title cannot be blank' if @book_title.blank?
      end
    end
  end
end
