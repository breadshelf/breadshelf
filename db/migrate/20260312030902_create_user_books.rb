class CreateUserBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :user_books do |t|
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.references :book, null: false, type: :uuid, foreign_key: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :user_books, [:user_id, :book_id]
  end
end
