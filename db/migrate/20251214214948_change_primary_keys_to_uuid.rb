class ChangePrimaryKeysToUuid < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    remove_column(:entries, :book_id)
    remove_column(:entries, :user_id)
    remove_column(:notes, :entry_id)

    change_column_default(:entries, :id, nil)
    change_column_default(:notes, :id, nil)
    change_column_default(:users, :id, nil)
    change_column_default(:books, :id, nil)

    change_column(:entries, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)
    change_column(:notes, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)
    change_column(:users, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)
    change_column(:books, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)

    add_column(:entries, :book_id, :uuid, null: false)
    add_column(:entries, :user_id, :uuid, null: false)
    add_column(:notes, :entry_id, :uuid, null: false)

    add_foreign_key(:entries, :books)
    add_foreign_key(:entries, :users)
    add_foreign_key(:notes, :entries)

    change_column_default(:events, :id, nil)
    change_column(:events, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)
  end
end
