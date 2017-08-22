desc "Import weather data from Polish IMGW. "
task :import_imgw => :environment do
  import = build_import_imgw
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_imgw
  print "Import begining.\n"
  file = open('http://danepubliczne.imgw.pl/api/data/synop/format/csv')
  csv_text = file.read
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    Measurement.create!(
      :station_number => row['id_stacji'],
      :date => row['data_pomiaru'],
      :hour => row['godzina_pomiaru'],
      :temperature => row['temperatura'],
      :wind_speed => row['predkosc_wiatru'],
      :wind_direct => row['kierunek_wiatru'],
      :humidity => row['wilgotnosc_wzgledna'],
      :et => row['odparowanie'],
      :rainfall => row['suma_opadu'],
      :preasure => row['cisnienie'])
  end
end
