class CreateTracks < ActiveRecord::Migration[8.0]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :location
      t.integer :length_meters
      t.boolean :is_indoor

      t.timestamps
    end
  end
end
