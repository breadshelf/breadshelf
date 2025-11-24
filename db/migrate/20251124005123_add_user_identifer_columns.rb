class AddUserIdentiferColumns < ActiveRecord::Migration[8.1]
  def change
    add_column(:users, :clerk_id, :string)
    add_column(:users, :unique_id, :uuid)

    add_column(:users, :clerk_id)
    add_index(:users, :unique_id)
  end
end
