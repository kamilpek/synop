desc "Import Polish IMGW stations from file. "
task :import_stations => :environment do
  import = build_import_stations
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_stations
  print "Import begining.\n"
  file = open('https://github.com/kamilpek/synop/blob/master/stacje.csv')
  csv_text = file.read
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Station.create!(
      :number => row['number'],
      :name => row['name'],
      :latitude => row['latitude'],
      :longitude => row['longitude'],
      :status => 1)
  end
end
