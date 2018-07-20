json.extract! gw_measur, :id, :gw_station_id, :datetime, :rain, :water, :winddir, :windlevel, :created_at, :updated_at
json.url gw_measur_url(gw_measur, format: :json)
