class CreateGwStations < ActiveRecord::Migration[5.0]
  def change
    create_table :gw_stations do |t|
      t.integer :no
      t.string :name
      t.float :lat
      t.float :lng
      t.boolean :active
      t.boolean :rain
      t.boolean :water
      t.boolean :winddir
      t.boolean :windlevel

      t.timestamps
    end
  end
end
