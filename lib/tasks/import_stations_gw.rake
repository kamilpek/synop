desc "Import Gdańskie Wody stations from file. "
task :import_stations_gw => :environment do
  import = build_import_stations_gw
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_stations_gw
  print "Import begining.\n"
  file = open('https://raw.githubusercontent.com/kamilpek/synop/master/stacje_gw.csv')
  csv_text = file.read
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    GwStation.create!(
      :no => row['no'],
      :name => row['name'],
      :lat => row['lat'],
      :lng => row['lon'],
      :active => row['active'],
      :rain => row['rain'],
      :water => row['water'],
      :winddir => row['winddir'],
      :windlevel => row['windlevel']
    )
  end
end
