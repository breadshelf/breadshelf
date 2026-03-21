module Public
  class UserBooksController < ApplicationController
    def index
      unless Flipper.enabled?(:mvp)
        redirect_to '/welcome'
        return
      end

      if current_user.nil? || current_user.user_books.active.empty?
        redirect_to new_user_book_path
        return
      end

      @user_books = current_user.user_books.includes(:book).where(active: true)
    end

    def new
    end

    def create
      user_book = Public::UserBooks::Create.call(user: current_user, book_params: book_params)

      if user_book.persisted?
        redirect_to user_books_path, notice: { message: 'Book added', status: 'success' }
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def book_params
      params.require(:book).permit(:title, :author)
    end
  end
end
