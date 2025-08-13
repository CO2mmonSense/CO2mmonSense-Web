class AddSensorIdTimestampIndexToReadings < ActiveRecord::Migration[8.0]
  def change
    add_index :readings, [:sensor_id, :timestamp, :id], order: { timestamp: :desc, id: :desc }
  end
end
