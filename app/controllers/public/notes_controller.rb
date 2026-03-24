module Public
  class NotesController < ApplicationController
    def show
      @note = Note.find(params[:id])
    end

    def new
      @entry = Entry.find(params[:entry_id])
      if @entry.notes.any?
        redirect_to entry_path(@entry)
        return
      end
      @note = Note.new
    end

    def create
      unless note_params[:content].blank?
        Public::Notes::Create.call(entry_id: params[:entry_id], content: note_params[:content])
      end
      head :ok
    end

    private

    def note_params
      params.require(:note).permit(:content)
    end
  end
end
