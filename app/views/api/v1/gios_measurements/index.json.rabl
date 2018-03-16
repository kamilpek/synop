object false
child :data do
  node (:gios_measurements_count) { @gios_measurements.size }
  child @gios_measurements do
    attributes :st_index, :co_index, :pm10_index, :c6h6_index, :no2_index, :pm25_index, :o3_index, :so2_index
    attributes :co_value, :pm10_value, :c6h6_value, :no2_value, :pm25_value, :o3_value, :so2_value
    attributes :co_date, :pm10_date, :c6h6_date, :no2_date, :pm25_date, :o3_date, :so2_date
    node(:co_value, :if => lambda { |m| m.co_value.nil? }) do |m| 0 end
    node(:pm10_value, :if => lambda { |m| m.pm10_value.nil? }) do |m| 0 end
    node(:c6h6_value, :if => lambda { |m| m.c6h6_value.nil? }) do |m| 0 end
    node(:no2_value, :if => lambda { |m| m.no2_value.nil? }) do |m| 0 end
    node(:pm25_value, :if => lambda { |m| m.pm25_value.nil? }) do |m| 0 end
    node(:o3_value, :if => lambda { |m| m.o3_value.nil? }) do |m| 0 end
    node(:so2_value, :if => lambda { |m| m.so2_value.nil? }) do |m| 0 end
    node(:calc_date, :if => lambda { |m| m.calc_date? }) do |m|
      m.calc_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:calc_date, :if => lambda { |m| m.calc_date.nil? }) do |m|
      DateTime.now.strftime("%Y-%m-%d; %H:%M")
    end
    node(:co_date, :if => lambda { |m| m.co_date? }) do |m|
      m.co_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:pm10_date, :if => lambda { |m| m.pm10_date? }) do |m|
      m.pm10_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:c6h6_date, :if => lambda { |m| m.c6h6_date? }) do |m|
      m.c6h6_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:no2_date, :if => lambda { |m| m.no2_date? }) do |m|
      m.no2_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:pm25_date, :if => lambda { |m| m.pm25_date? }) do |m|
      m.pm25_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:o3_date, :if => lambda { |m| m.o3_date? }) do |m|
      m.o3_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:so2_date, :if => lambda { |m| m.so2_date? }) do |m|
      m.so2_date.strftime("%Y-%m-%d; %H:%M")
    end
    node(:station) do |m|
      "#{GiosStation.where(number:m.station).pluck(:name).last}"
    end
    node(:latitude) do |m|
      "#{GiosStation.where(number:m.station).pluck(:latitude).last}"
    end
    node(:longitude) do |m|
      "#{GiosStation.where(number:m.station).pluck(:longitude).last}"
    end
  end
end
