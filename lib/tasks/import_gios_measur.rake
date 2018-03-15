desc "Import Polish GIOS measurments from API. "
task :import_gios_measur => :environment do
  import = build_import_gios_measur
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_gios_measur
  print "Import begining.\n"

  GiosStation.all.each do |station|
    co_value = no2_value = o3_value = pm10_value = pm25_value = so2_value = c6h6_value = calc_date = 0
    st_index = co_index = no2_index = o3_index = pm10_index = pm25_index = so2_index = c6h6_index = 0
    co_date = no2_date = o3_date = pm10_date = pm25_date = so2_date = c6h6_date = 0

    sensors = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/station/sensors/#{station.number}"), nil, Encoding::UTF_8.to_s))
    for i in 0..sensors.count-1
      data = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/data/getData/#{sensors[i]["id"]}")))["values"]
      value = 0
      date = 0
      if data != []
        value = data[1]["value"]
        date = data[1]["date"]
      end
      case sensors[i]["param"]["idParam"].to_i
      when 1
        value == "null" ? so2_value = 0 : so2_value = value
        date == "null" ? so2_date = 0 : so2_date = date
      when 3
        value == "null" ? pm10_value = 0 : pm10_value = value
        date == "null" ? pm10_date = 0 : pm10_date = date
      when 5
        value == "null" ? o3_value = 0 : o3_value = value
        date == "null" ? o3_date = 0 : o3_date = date
      when 6
        value == "null" ? no2_value = 0 : no2_value = value
        date == "null" ? no2_date = 0 : no2_date = date
      when 8
        value == "null" ? co_value = 0 : co_value = value
        date == "null" ? co_date = 0 : co_date = date
      when 10
        value == "null" ? c6h6_value = 0 : c6h6_value = value
        date == "null" ? c6h6_date = 0 : c6h6_date = date
      when 69
        value == "null" ? pm25_value = 0 : pm25_value = value
        date == "null" ? pm25_date = 0 : pm25_date = date
      end
    end

    index = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/#{station.number}")))
    st_calc_date = index["stCalcDate"]
    if st_calc_date
      calc_date = DateTime.parse(st_calc_date).strftime("%d.%m.%Y, %H:%M")
      st_index = index["stIndexLevel"]["id"] if index["stIndexLevel"]
      co_index = index["coIndexLevel"]["id"] if index["coIndexLevel"]
      pm10_index = index["pm10IndexLevel"]["id"] if index["pm10IndexLevel"]
      c6h6_index = index["c6h6IndexLevel"]["id"] if index["c6h6IndexLevel"]
      no2_index = index["no2IndexLevel"]["id"] if index["no2IndexLevel"]
      pm25_index = index["pm25IndexLevel"]["id"] if index["pm25IndexLevel"]
      o3_index = index["o3IndexLevel"]["id"] if index["o3IndexLevel"]
      so2_index = index["so2IndexLevel"]["id"] if index["so2IndexLevel"]
    else
      calc_date = DateTime.now.strftime("%d.%m.%Y, %H:%M")
      st_index = 0
      co_index = 0
      pm10_index = 0
      c6h6_index = 0
      no2_index = 0
      pm25_index = 0
      o3_index = 0
      so2_index = 0
    end

    GiosMeasurment.create(
      :calc_date => calc_date,
      :st_index => st_index,
      :co_index => co_index,
      :co_value => co_value,
      :co_date => co_date,
      :pm10_index  => pm10_index,
      :pm10_value => pm10_value,
      :pm10_date => pm10_date,
      :c6h6_index => c6h6_index,
      :c6h6_value => c6h6_value,
      :c6h6_date => c6h6_date,
      :no2_index => no2_index,
      :no2_value => no2_value,
      :no2_date => no2_date,
      :pm25_index => pm25_index,
      :pm25_value => pm25_value,
      :pm25_date => pm25_date,
      :o3_index => o3_index,
      :o3_value => o3_value,
      :o3_date => o3_date,
      :so2_index => so2_index,
      :so2_value => so2_value,
      :so2_date => so2_date,
      :station => station.number
    )
  end

end
