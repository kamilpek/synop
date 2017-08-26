desc "Import forecast data from Polish IMGW [XML]. "
task :import_imgw_xml => :environment do
  import = build_import_imgw_xml
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_imgw_xml
  print "Import begining.\n"
  doc = Nokogiri::XML(open("https://danepubliczne.imgw.pl/api/data/synop/format/xml"))
  doc.xpath('//item').each do |row|
    Measurement.create!(
      :station_number => row.xpath('id_stacji').text,
      :date => row.xpath('data_pomiaru').text,
      :hour =>  row.xpath('godzina_pomiaru').text,
      :temperature => row.xpath('temperatura').text,
      :wind_speed => row.xpath('predkosc_wiatru').text,
      :wind_direct => row.xpath('kierunek_wiatru').text,
      :humidity => row.xpath('wilgotnosc_wzgledna').text,
      :et =>  row.xpath('odparowanie').text,
      :rainfall => row.xpath('suma_opadu').text,
      :preasure => row.xpath('cisnienie').text)
  end
end
