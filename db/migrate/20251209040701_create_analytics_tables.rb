class CreateAnalyticsTables < ActiveRecord::Migration[8.1]
  def change
    create_table 'analytics.events' do |t|
      t.string(:event, null: false)
      t.string(:subject)
      t.timestamps
    end
  end
end
