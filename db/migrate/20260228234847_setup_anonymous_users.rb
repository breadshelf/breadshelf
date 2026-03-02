class SetupAnonymousUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :anonymous_users, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.timestamps
    end

    add_column :entries, :anonymous_user_id, :uuid
    add_index :entries, :anonymous_user_id
    add_foreign_key :entries, :anonymous_users
  end
end
