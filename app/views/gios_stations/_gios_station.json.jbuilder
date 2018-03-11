json.extract! gios_station, :id, :name, :latitude, :longitude, :number, :city, :address, :created_at, :updated_at
json.url gios_station_url(gios_station, format: :json)
