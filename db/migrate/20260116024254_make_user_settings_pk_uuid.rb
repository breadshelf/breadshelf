class MakeUserSettingsPkUuid < ActiveRecord::Migration[8.1]
  def change
    change_column_default(:user_settings, :id, nil)
    change_column(:user_settings, :id, :uuid, default: 'gen_random_uuid()', using: 'gen_random_uuid()', null: false)
  end
end
