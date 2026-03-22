module Public
  module Entries
    class Create < ApplicationService
      def initialize(user:, user_book_id:)
        @user = user
        @user_book_id = user_book_id
      end

      def call
        raise(ArgumentError, 'User book must exist') unless @user_book_id

        user_book = @user.user_books.find(@user_book_id)
        Entry.create!(user_book: user_book)
      end
    end
  end
end
