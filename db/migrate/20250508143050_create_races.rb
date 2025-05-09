class CreateRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :races do |t|
      t.references :track, null: false, foreign_key: true
      t.string :name
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
