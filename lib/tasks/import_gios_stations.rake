desc "Import Polish GIOS stations from API. "
task :import_gios_stations => :environment do
  import = build_import_gios_stations
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_gios_stations
  print "Import begining.\n"

  stations = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/station/findAll"), nil, Encoding::UTF_8.to_s))
  for i in 0..stations.count-1
    GiosStation.create!(
      :number => stations[i]['id'],
      :name => stations[i]['stationName'],
      :latitude => stations[i]['gegrLat'],
      :longitude => stations[i]['gegrLon'],
      :city => stations[i]['city']['name'],
      :address => stations[i]['addressStreet']
    )
  end
end
