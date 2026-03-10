class AddFinishBookToEntry < ActiveRecord::Migration[8.1]
  def change
    add_column(:entries, :finished_book, :boolean, default: false)
  end
end
