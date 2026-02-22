
module Public
  class EntriesController < ApplicationController
    def index; end

    def new
    end

    def create
      book_title = entries_params[:book_title]

      if current_user
        entry = Public::Entries::Create.call(user: current_user, book_title: book_title)
        redirect_to entry_path(entry), notice: { message: 'Entry created successfully', status: 'success' }
      else
        redirect_to new_entry_path, alert: { message: 'Please sign in to create an entry', status: 'error' }
      end
    end

    def show
      @entry = Entry.find(params[:id])
    end

    private

    def entries_params
      params.require(:entry).permit(:book_title)
    end
  end
end
