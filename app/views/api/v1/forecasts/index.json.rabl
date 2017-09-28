object false
child :data do
  node (:forecasts_count) { @forecasts.size }
  child @forecasts do
    attributes :hours, :temperatures
  end
end
