object false
child :data do
  node (:gios_stations_count) { @gios_stations.size }
  child @gios_stations do
    attributes :name, :number, :latitude, :longitude, :id
  end
end
