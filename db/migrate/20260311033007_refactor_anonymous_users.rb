class RefactorAnonymousUsers < ActiveRecord::Migration[8.1]
  def change
    # Add anonymous boolean column to users table
    add_column :users, :anonymous, :boolean, default: false, null: false

    # Remove foreign key constraint from entries to anonymous_users
    remove_foreign_key :entries, :anonymous_users

    # Remove the anonymous_user_id column from entries
    remove_column :entries, :anonymous_user_id

    # Drop the anonymous_users table
    drop_table :anonymous_users
  end
end
