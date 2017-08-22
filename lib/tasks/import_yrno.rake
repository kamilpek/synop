desc "Import forecast data from Norwegian yr.no [XML]. "
task :import_yrno => :environment do
  import = build_import_yrno
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

def build_import_yrno
  print "Import begining.\n"
  doc1 = Nokogiri::XML(open("http://api.geonames.org/findNearbyPlaceName?lat=54.114&lng=17.87012&username=kamilpek"))
  geoid = doc1.xpath('//geoname').xpath('geonameId').text

  doc2 = Nokogiri::XML(open("http://api.geonames.org/get?geonameId=#{geoid}&username=kamilpek&style=full"))
  countryname = doc2.xpath('//geoname').xpath('countryName').text
  adminname = doc2.xpath('//geoname').xpath('adminName1').text
  cityname = doc2.xpath('//geoname').xpath('name').text

  topo = "#{countryname}/#{adminname}/#{cityname}"

  doc3 = Nokogiri::XML(open("http://www.yr.no/place/#{topo}/forecast.xml"))
  doc3.xpath('//tabular').each do |row|
    row.xpath('//time').each do |temp|
      puts "#{temp.xpath('@from').text} – #{temp.xpath('temperature/@value').text}"
    end
  end
end
