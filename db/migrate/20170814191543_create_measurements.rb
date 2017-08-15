class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.date :date
      t.integer :hour
      t.float :temperature
      t.float :wind_speed
      t.integer :wind_direct
      t.float :humidity
      t.float :preasure
      t.float :rainfall
      t.float :et

      t.timestamps
    end
  end
end
