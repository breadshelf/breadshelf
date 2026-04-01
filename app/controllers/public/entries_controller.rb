
module Public
  class EntriesController < ApplicationController
    before_action :ensure_mvp_enabled

    def new
      redirect_to new_user_book_path
    end

    def create
      entry = Public::Entries::Create.call(user: current_user, user_book_id: params[:user_book_id])
      redirect_to read_path(entry_id: entry.id)
    end

    def read
      @entry = Entry.find(params[:entry_id])
      if @entry.end_time.present?
        redirect_to new_note_path(entry_id: @entry.id)
      end
    end

    def start
      Public::Entries::Start.call(entry_id: params[:id])
      head :ok
    end

    def end
      entry = Public::Entries::End.call(entry_id: params[:id])
      redirect_to new_note_path(entry_id: entry.id)
    end

    def finish
      entry = Public::Entries::Finish.call(entry_id: params[:id], finished_book: params[:finished_book])
      redirect_to entry_path(entry), status: :see_other
    end

    def share
      entry = Entry.find(params[:id])
      Public::Entries::Share.call(entry: entry)
      head :ok
    end

    def show
      @entry = Entry.includes(notes: [], user_book: :book).find(params[:id])
      @reading_crumbs = @entry.start_time && @entry.end_time ?
        (@entry.end_time - @entry.start_time).to_i / 60 / 5 : 0
      @note = @entry.notes.first
      @note_crumbs = @note ? [@note.content.length / 100, 10].min : 0
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
