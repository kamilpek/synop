json.extract! measurement, :id, :date, :hour, :temperature, :wind_speed, :wind_direct, :humidity, :preasure, :rainfall, :et, :created_at, :updated_at
json.url measurement_url(measurement, format: :json)
