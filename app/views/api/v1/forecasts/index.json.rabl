object false
child :data do
  node (:forecasts_count) { @forecasts.size }
  child @forecasts do
    node(:station_number) do |m|
      "#{Station.where(number:m.station_number).pluck(:name).last}"
    end
    node(:date, :if => lambda { |m| m.date? }) do |m|
      m.date.strftime("%d.%m.%Y")
    end
    node(:next, :if => lambda { |m| m.next? }) do |m|
      m.next.strftime("%d.%m.%Y, %H:%M")
    end
    attributes :hour, :times_from, :times_to
    attributes :temperatures, :wind_speeds, :wind_directs, :preasures, :situations, :precipitations
  end
end
