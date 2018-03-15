object false
child :data do
  node (:metar_raports_count) { @metar_raports.size }
  child @metar_raports do
    attributes :day, :hour, :metar, :message
    attributes :visibility, :cloud_cover, :wind_direct, :wind_speed, :temperature, :pressure, :situation
    node(:created_at, :if => lambda { |m| m.created_at? }) do |m|
      m.created_at.strftime("%d.%m.%Y")
    end
    node(:station) do |m|
      "#{MetarStation.where(number:m.station).pluck(:name).last}"
    end
    node(:latitude) do |m|
      "#{MetarStation.where(number:m.station).pluck(:latitude).last}"
    end
    node(:longitude) do |m|
      "#{MetarStation.where(number:m.station).pluck(:longitude).last}"
    end
  end
end
