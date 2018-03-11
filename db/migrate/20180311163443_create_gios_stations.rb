class CreateGiosStations < ActiveRecord::Migration[5.0]
  def change
    create_table :gios_stations do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :number
      t.string :city
      t.string :address

      t.timestamps
    end
  end
end
