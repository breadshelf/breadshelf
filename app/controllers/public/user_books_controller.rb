module Public
  class UserBooksController < ApplicationController
    before_action :check_mvp

    def index
      if current_user.nil? || current_user.user_books.active.empty?
        redirect_to new_user_book_path
        return
      end

      @user_books = current_user.user_books.includes(:book).where(active: true)

      @last_note_ids = @user_books.each_with_object({}) do |user_book, hash|
        last_entry = Entry.where(user_book: user_book).order(:created_at).last
        hash[user_book.id] = last_entry&.notes&.last&.id
      end
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

    def check_mvp
      unless Flipper.enabled?(:mvp)
        redirect_to '/welcome'
        return
      end
    end
  end
end
