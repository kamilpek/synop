class AddParamsToMetarRaports < ActiveRecord::Migration[5.0]
  def change
    add_column :metar_raports, :visibility, :string
    add_column :metar_raports, :cloud_cover, :string
    add_column :metar_raports, :wind_direct, :string
    add_column :metar_raports, :wind_speed, :string
    add_column :metar_raports, :temperature, :string
    add_column :metar_raports, :pressure, :string
    add_column :metar_raports, :situation, :string
  end
end
