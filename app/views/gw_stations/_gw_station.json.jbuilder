json.extract! gw_station, :id, :no, :name, :lat, :lng, :active, :rain, :water, :winddir, :windlevel, :created_at, :updated_at
json.url gw_station_url(gw_station, format: :json)
