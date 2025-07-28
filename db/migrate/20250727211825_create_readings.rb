class CreateReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :readings do |t|
      t.float :pm25
      t.float :pm10
      t.float :pm100
      t.float :co2
      t.float :temperature
      t.float :relative_humidity
      t.integer :battery_level
      t.datetime :timestamp
      t.references :sensor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
