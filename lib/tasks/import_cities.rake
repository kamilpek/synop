desc "Import Polish cities from file. "
task :import_cities => :environment do
  import = build_import_cities
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_cities
  print "Import begining.\n"
  # file = open('https://raw.githubusercontent.com/kamilpek/synop/master/TERC_Urzedowy_2018-03-16.csv')
  # file = open('https://raw.githubusercontent.com/kamilpek/synop/master/terc.csv')
  file = open('terc_empty.csv')
  csv_text = file.read
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    if row["genre"] == "4"
      City.create!(
        :province => row["province"],
        :county => row["county"],
        :commune => row["commune"],
        :genre => row["genre"],
        :name => row["name"],
        :name_add => row["name_add"]
        # :province => row["WOJ"],
        # :county => row["POW"],
        # :commune => row["GMI"],
        # :genre => row["RODZ"],
        # :name => row["NAZWA"],
        # :name_add => row["NAZWA_DOD"]
      )
      sleep(0.3)
    end
  end
end
