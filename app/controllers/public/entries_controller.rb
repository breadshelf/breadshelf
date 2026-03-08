
module Public
  class EntriesController < ApplicationController
    before_action :ensure_mvp_enabled

    def new
    end

    def create
      entry = Public::Entries::Create.call(
        book_details: entries_params,
        user: current_user,
        anonymous_user: current_anonymous_user
      )
      redirect_to entry_path(entry), notice: { message: 'Entry created successfully', status: 'success' }
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
