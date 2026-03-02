
module Public
  class EntriesController < ApplicationController
    before_action :ensure_mvp_enabled

    def new
    end

    def create
      book_title = entries_params[:book_title]
      author_name = entries_params[:author_name]

      if current_user
        entry = Public::Entries::Create.call(user: current_user, book_title: book_title, author_name: author_name)
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
      params.require(:entry).permit(:book_title, :author_name)
    end

    def ensure_mvp_enabled
      unless Flipper.enabled?(:mvp)
        raise(ApplicationController::NotFoundError)
      end
    end
  end
end
