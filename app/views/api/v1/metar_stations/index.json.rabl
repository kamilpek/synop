object false
child :data do
  node (:metar_stations_count) { @metar_stations.size }
  child @metar_stations do
    attributes :name, :number, :latitude, :longitude, :id, :elevation
  end
end
