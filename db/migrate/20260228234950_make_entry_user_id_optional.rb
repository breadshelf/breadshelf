class MakeEntryUserIdOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :entries, :user_id, true
  end
end
