class CreateAnalyticsAndMonitoringSchemas < ActiveRecord::Migration[8.1]
  def up
    execute('CREATE SCHEMA IF NOT EXISTS analytics')
    execute('CREATE SCHEMA IF NOT EXISTS monitoring')
  end

  def down
    execute('DROP SCHEMA IF EXISTS analytics CASCADE')
    execute('DROP SCHEMA IF EXISTS monitoring CASCADE')
  end
end
