desc "Import Polish metar stations from file. "
task :import_stations_metar => :environment do
  import = build_import_stations_metar
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_stations_metar
  print "Import begining.\n"
  file = open('https://raw.githubusercontent.com/kamilpek/synop/master/stacje_metar.csv')
  csv_text = file.read
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    MetarStation.create!(
      :number => row['number'],
      :name => row['name'],
      :latitude => ((row['latitude']).to_f)/100,
      :longitude => ((row['longitude']).to_f)/100,
      :elevation => row['elevation'],
      :status => 1)
  end
end
