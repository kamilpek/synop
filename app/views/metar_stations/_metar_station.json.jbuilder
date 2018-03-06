json.extract! metar_station, :id, :name, :number, :latitude, :longitude, :elevation, :status, :created_at, :updated_at
json.url metar_station_url(metar_station, format: :json)
