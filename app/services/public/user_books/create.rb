module Public
  module UserBooks
    class Create < ApplicationService
      def initialize(user:, book_params:)
        @user = user
        @book_params = book_params
      end

      def call
        @book = Public::Books::FindOrCreate.call(@book_params[:title], author: @book_params[:author])
        @user_book = @user.user_books.build(book: @book, active: true)
        if @user_book.save
          @user_book
        else
          raise ActiveRecord::RecordInvalid.new(@user_book)
        end
      end
    end
  end
end
