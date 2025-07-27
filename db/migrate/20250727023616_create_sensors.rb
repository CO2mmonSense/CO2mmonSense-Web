class CreateSensors < ActiveRecord::Migration[8.0]
  def change
    create_table :sensors do |t|
      t.string :name, null: false
      t.string :sender_id, null: false
      t.st_point :coordinates, geographic: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sensors, :sender_id
    add_index :sensors, :coordinates, using: :gist
  end
end
