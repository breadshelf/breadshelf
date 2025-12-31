class CreateSettingsAndUserSettingsTable < ActiveRecord::Migration[8.1]
  def change
    create_table :settings, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :user_settings do |t|
      t.uuid :user_id, null: false
      t.uuid :setting_id, null: false
      t.boolean :enabled, default: false, null: false
      t.timestamps
    end

    add_foreign_key :user_settings, :users
    add_foreign_key :user_settings, :settings
  end
end
