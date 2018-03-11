class CreateGiosMeasurments < ActiveRecord::Migration[5.0]
  def change
    create_table :gios_measurments do |t|
      t.integer :station
      t.datetime :calc_date
      t.integer :st_index
      t.integer :co_index
      t.integer :pm10_index
      t.integer :c6h6_index
      t.integer :no2_index
      t.integer :pm25_index
      t.integer :o3_index
      t.integer :so2_index
      t.float :co_value
      t.float :pm10_value
      t.float :c6h6_value
      t.float :no2_value
      t.float :pm25_value
      t.float :o3_value
      t.float :so2_value
      t.datetime :co_date
      t.datetime :pm10_date
      t.datetime :c6h6_date
      t.datetime :no2_date
      t.datetime :pm25_date
      t.datetime :o3_date
      t.datetime :so2_date
    end
  end
end
