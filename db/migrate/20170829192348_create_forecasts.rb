class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.integer :station_number
      t.datetime :current
      t.datetime :next
      t.string :temperatures, array:true
      t.float :wind_speeds, array:true
      t.float :wind_directs, array:true
      t.float :preasures, array:true
      t.string :situations, array:true
      t.float :precipitations, array:true
      t.datetime :times_from, array:true
      t.datetime :times_to, array:true 

      t.timestamps
    end
  end
end
