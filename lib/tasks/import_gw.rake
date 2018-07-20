desc "Import Gdańskie Wody measurements from API. "
task :import_gw => :environment do
  import = build_import_gw
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

# https://pomiary.gdanskiewody.pl/rest/measurments/1/rain/2018-07-18/
# measurments = JSON.parse(Nokogiri.HTML(open("https://pomiary.gdanskiewody.pl/rest/measurments/1/rain/2018-07-18/"), nil, Encoding::UTF_8.to_s))
# measurments = JSON.parse(Nokogiri.HTML(open("https://pomiary.gdanskiewody.pl/rest/measurments/35/rain/2018-07-22/"), nil, Encoding::UTF_8.to_s))
# measurments = JSON.parse(Nokogiri.HTML(open("https://pomiary.gdanskiewody.pl/rest/measurments/140/water/2018-07-22/"), nil, Encoding::UTF_8.to_s))

def build_import_gw
  print "Import begining.\n"
  datetime = DateTime.now.utc
  datetime.strftime("%H").to_i < 6 ? datetime : datetime = datetime - (2/24.0)
  stations = GwStation.where.not(no:7).where.not(no:15)
  stations.each do |station|
    kind = "water" if station.water
    kind = "rain" if station.rain
    measurments = JSON.parse(Nokogiri.HTML(open("https://pomiary.gdanskiewody.pl/rest/measurments/#{station.no}/#{kind}/#{datetime.strftime("%Y-%m-%d")}/"), nil, Encoding::UTF_8.to_s))
    if measurments["status"] == "success"
      measur = 0
      for i in 0..measurments.count-1
        break if measurments["data"][i][1] == nil
        measur = measurments["data"][i][1]
        datetime_measur = measurments["data"][i][0]
      end
      kind == "water" ? water = measur : water = nil
      kind == "rain" ? rain = measur : rain = nil
      GwMeasur.create!(:gw_station_id => station.id, :rain => rain, :water => water, :datetime => datetime_measur)
    end
  end
end
