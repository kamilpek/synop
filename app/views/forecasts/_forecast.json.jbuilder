json.extract! forecast, :id, :station_number, :current, :next, :temperatures, :wind_speeds, :wind_directs, :preasures, :situations, :precipitations, :times_from, :times_to, :created_at, :updated_at
json.url forecast_url(forecast, format: :json)
