class CreateLaps < ActiveRecord::Migration[8.0]
  def change
    create_table :laps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true
      t.integer :lap_number
      t.float :lap_time_seconds
      t.integer :position

      t.timestamps
    end
  end
end
