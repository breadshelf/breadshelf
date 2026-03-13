module Public
  class UserBooksController < ApplicationController
    def index
      unless Flipper.enabled?(:mvp)
        redirect_to '/welcome' and return
      end

      if current_user.user_books.active.empty?
        redirect_to new_user_book_path and return
      end

      # Fallback to direct query if service object is not available
      @user_books = if defined?(Public::UserBooks::List)
        Public::UserBooks::List.call(user: current_user, params: params)
      else
        current_user.user_books.includes(:book).where(active: true)
      end
    end

    def new
    end

    def create
      result = Public::UserBooks::Create.call(user: current_user, book_params: book_params)

      if result.success?
        redirect_to user_books_path, notice: { message: 'Book added', status: 'success' }
      else
        @book = Public::Book.new(book_params)
        @errors = result.errors
        render :new, status: :unprocessable_entity
      end
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :isbn)
    end
  end
end
