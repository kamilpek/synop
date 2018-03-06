json.extract! metar_raport, :id, :station, :day, :hour, :metar, :message, :created_at, :updated_at
json.url metar_raport_url(metar_raport, format: :json)
