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

  Station.all.each do |station|
    doc1 = Nokogiri::XML(open("http://api.geonames.org/findNearbyPlaceName?lat=#{station.latitude}&lng=#{station.longitude}&username=kamilpek"))
    geoid = doc1.xpath('//geoname').xpath('geonameId').text
    doc2 = Nokogiri::XML(open("http://api.geonames.org/get?geonameId=#{geoid}&username=kamilpek&style=full"))
    countryname = doc2.xpath('//geoname').xpath('countryName').text
    adminname = doc2.xpath('//geoname').xpath('adminName1').text
    if adminname == 'Mazovia'
      adminname = 'Masovia'
    elsif adminname == 'Łódź Voivodeship'
      adminname = 'Łódź'
    end
    cityname = doc2.xpath('//geoname').xpath('toponymName').text
    encoded_url = URI.encode("http://www.yr.no/place/#{countryname}/#{adminname}/#{cityname}/forecast.xml")

    temperatures = []
    wind_speeds = []
    wind_directs = []
    preasures = []
    precipitations = []
    situations = []
    times_from = []
    times_to = []
    station_number = station.number
    doc3 = Nokogiri::XML(open(URI.parse(encoded_url)))
    forecast_date = DateTime.parse(doc3.xpath('//meta').xpath('//lastupdate').text).strftime("%Y-%m-%d")
    forecast_hour = DateTime.parse(doc3.xpath('//meta').xpath('//lastupdate').text).strftime("%H")
    forecast_next = DateTime.parse(doc3.xpath('//meta').xpath('//nextupdate').text).strftime("%Y-%m-%dT%H:%M")
    doc3.xpath('//tabular').each do |row|
      row.xpath('//time').each do |time|
        temperatures.push(time.xpath('temperature/@value').text)
        wind_speeds.push(time.xpath('windSpeed/@mps').text)
        wind_directs.push(time.xpath('windDirection/@deg').text)
        preasures.push(time.xpath('pressure/@value').text)
        precipitations.push(time.xpath('precipitation/@value').text)
        situations.push(time.xpath('symbol/@name').text)
        times_from.push(time.xpath('@from').text)
        times_to.push(time.xpath('@to').text)
      end
      Forecast.create!(
        :station_number => station_number,
        :next => forecast_next,
        :temperatures => temperatures,
        :wind_speeds => wind_speeds,
        :wind_directs => wind_directs,
        :preasures => preasures,
        :situations => situations,
        :precipitations => precipitations,
        :times_from => times_from,
        :times_to => times_to,
        :hour => forecast_hour,
        :date => forecast_date)
    end
  end

end
