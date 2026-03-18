class ChangeUserBookPrimaryKey < ActiveRecord::Migration[8.1]
  def change
    change_column_default(:user_books, :id, nil)
    change_column(:user_books, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)
  end
end
