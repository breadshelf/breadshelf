
module Public
  class EntriesController < ApplicationController
    before_action :ensure_mvp_enabled

    def new
      redirect_to new_user_book_path
    end

    def create
      if params[:user_book_id].present?
        user_book = current_user.user_books.find(params[:user_book_id])
        entry = Entry.create!(user_book: user_book)
        redirect_to read_path(entry_id: entry.id)
      else
        entry = Public::Entries::Create.call(
          book_details: entries_params,
          user: current_user
        )
        redirect_to entry_path(entry), notice: { message: 'Entry created successfully', status: 'success' }
      end
    end

    def show
      @entry = Entry.find(params[:id])
    end

    def read
      @entry = Entry.find(params[:entry_id])
    end

    def start
      @entry = Entry.find(params[:id])
      @entry.update!(start_time: Time.current)
      head :ok
    end

    def end
      head :not_implemented
    end

    private

    def entries_params
      params.require(:entry).permit(:book_title, :author_name)
    end

    def ensure_mvp_enabled
      unless Flipper.enabled?(:mvp)
        raise(ApplicationController::NotFoundError)
      end
    end
  end
end
