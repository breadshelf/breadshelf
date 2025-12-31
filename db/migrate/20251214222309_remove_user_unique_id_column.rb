class RemoveUserUniqueIdColumn < ActiveRecord::Migration[8.1]
  def change
    remove_column(:users, :unique_id, :uuid)
  end
end
