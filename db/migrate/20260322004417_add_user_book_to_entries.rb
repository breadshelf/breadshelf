class AddUserBookToEntries < ActiveRecord::Migration[8.1]
  def up
    add_reference :entries, :user_book, type: :uuid, null: true, foreign_key: { to_table: 'public.user_books' }, index: true

    change_column_null :entries, :user_book_id, false
    remove_column :entries, :user_id
    remove_column :entries, :book_id
  end

  def down
    add_column :entries, :book_id, :uuid
    add_column :entries, :user_id, :uuid

    change_column_null :entries, :book_id, false
    remove_reference :entries, :user_book, index: true, foreign_key: { to_table: 'public.user_books' }
  end
end
