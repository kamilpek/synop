desc "Import Polish IMGW hydrologic stations from json. "
task :import_stations_hydro => :environment do
  import = build_import_stations_hydro
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_stations_hydro
  print "Import begining.\n"
  stations = JSON.parse(Nokogiri.HTML(open("https://danepubliczne.imgw.pl/api/data/hydro/"), nil, Encoding::UTF_8.to_s))
  for i in 0..stations.count-1
    StationHydro.create!(
      :number => stations[i]["id_stacji"],
      :name => stations[i]["stacja"],
      :river => stations[i]["rzeka"]
    )
  end
end
