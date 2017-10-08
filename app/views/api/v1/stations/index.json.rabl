object false
child :data do
  node (:stations_count) { @stations.size }
  child @stations do
    attributes :name, :number, :latitude, :longitude, :id
  end
end
