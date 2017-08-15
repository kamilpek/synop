class AddStationToMeasurements < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :station_number, :integer
  end
end
