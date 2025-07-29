class CreateApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :api_keys do |t|
      t.references :bearer, polymorphic: true
      t.string :name
      t.string :token_digest, null: false
      t.string :common_prefix, null: false
      t.string :random_prefix, null: false
      t.datetime :expires_at
      t.timestamps
    end

    add_index :api_keys, :token_digest, unique: true
  end
end
