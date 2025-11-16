class CreateEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :active, null: false, default: true
      t.integer :crumbs, null: false, default: 0

      t.timestamps
    end
  end
end
