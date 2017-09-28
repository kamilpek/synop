object false
child :data do
  node (:measurements_count) { @measurements.size }
  child @measurements do
    attributes :hour, :temperature, :wind_speed, :wind_direct, :humidity, :preasure, :rainfall
    node(:date, :if => lambda { |m| m.date? }) do |m|
      m.date.strftime("%d.%m.%Y")
    end
    node(:station_number) do |m|
      "#{Station.where(number:m.station_number).pluck(:name).last}"
    end
  end
end
