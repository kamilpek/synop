class CreateMetarStations < ActiveRecord::Migration[5.0]
  def change
    create_table :metar_stations do |t|
      t.string :name
      t.integer :number
      t.float :latitude
      t.float :longitude
      t.integer :elevation
      t.boolean :status

      t.timestamps
    end
  end
end
