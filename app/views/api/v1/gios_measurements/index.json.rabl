object false
child :data do
  node (:gios_measurements_count) { @gios_measurements.size }
  child @gios_measurements do
    attributes :st_index, :co_index, :pm10_index, :c6h6_index, :no2_index, :pm25_index, :o3_index, :so2_index
    attributes :co_value, :pm10_value, :c6h6_value, :no2_value, :pm25_value, :o3_value, :so2_value
    attributes :co_date, :pm10_date, :c6h6_date, :no2_date, :pm25_date, :o3_date, :so2_date
    node(:calc_date, :if => lambda { |m| m.calc_date? }) do |m|
      m.calc_date.strftime("%d.%m.%Y")
    end
    node(:station) do |m|
      "#{GiosStation.where(number:m.station).pluck(:name).last}"
    end
  end
end
