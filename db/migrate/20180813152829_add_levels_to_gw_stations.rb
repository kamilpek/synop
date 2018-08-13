class AddLevelsToGwStations < ActiveRecord::Migration[5.0]
  def change
    add_column :gw_stations, :level_normal, :float
    add_column :gw_stations, :level_max, :float
    add_column :gw_stations, :level_rise, :float
  end
end
