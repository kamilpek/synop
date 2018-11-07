desc "Import Polish GIOS measurments from API. "
task :import_gios_measur => :environment do
  import = build_import_gios_measur
  if import.nil?
    puts "Something is wrong."
  else
    puts "Successfull import."
  end
end

class GiosMeasurmentApiCrawler
  @@stations = nil
  @@allSensors = Array.new
  @@allValues = Array.new
  @@allIndexes = Array.new
  @@valueTypes = {"10" => "c6h6_value", "8" => "co_value", "6" => "no2_value", "5" => "o3_value", "1" => "so2_value",
    "3" => "pm10_value", "69" => "pm25_value"}
  @@indexTypes = {"stIndexLevel" => "st_index", "so2IndexLevel" => "so2_index", "no2IndexLevel" => "no2_index",
    "coIndexLevel" => "co_index", "pm10IndexLevel" => "pm10_index", "pm25IndexLevel" => "pm25_index", "c6h6IndexLevel" => "c6h6_index"}
  @@calc_date = DateTime.now.strftime("%d.%m.%Y, %H:%M")

  def initialize
    getStations
    downloadSensors
  end

  def getStations
    @@stations = GiosStation.all
  end

  def downloadSensors
    @@stations.each do |station|
      sensors = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/station/sensors/#{station.number}"), nil, Encoding::UTF_8.to_s))
      @@allSensors.push(sensors)
    end
  end

  def getSensors
    @@allSensors
  end

  def downloadValues
    @@allSensors.each do |stationSensors|
      stationSensors.each do |sensor|
        setSensorValue(sensor["stationId"], sensor["id"], sensor["param"]["idParam"])
      end
    end
  end

  def setSensorValue(station_id, sensor_id, param_id)
    @@allValues.push({"station_id" => station_id, "#{param_id}_value" => downloadSensorValue(sensor_id)})
  end

  def downloadSensorValue(sensor_id)
    json = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/data/getData/#{sensor_id}")))["values"]
    json = json.find { |x| !x["value"].blank? }
    json == nil ? nil : json["value"]
  end

  def getValues
    @@allValues
  end

  def downloadIndexes
    @@stations.each do |station|
      @@indexTypes.keys.each do |indexType|
        setSensorIndex(station["number"], indexType)
      end
    end
  end

  def setSensorIndex(station_id, index_type)
    @@allIndexes.push({"station_id" => station_id, "#{index_type}" => downloadSensorIndex(station_id, index_type)})
  end

  def downloadSensorIndex(station_number, index_type)
    index = JSON.parse(Nokogiri.HTML(open("http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/#{station_number}")))["#{index_type}"]
    index == nil ? nil : index["id"]
  end

  def getIndexes
    @@allIndexes
  end

  def createRecordInDb
    @@stations.each do |station|
      stationIndexes = @@allIndexes.select { |index| index["station_id"] == station.number }
      stationValues = @@allValues.select { |value| value["station_id"] == station.number }
      GiosMeasurment.create(
        :calc_date => @@calc_date,
        :st_index => stationIndexes.select { |index_value| index_value["stIndexLevel"] != nil }.dig(0, "stIndexLevel"),
        :co_index => stationIndexes.select { |index_value| index_value["coIndexLevel"] != nil }.dig(0, "coIndexLevel"),
        :co_value => stationValues.select { |sensor_value| sensor_value["8_value"] != nil }.dig(0, "8_value"),
        :co_date => 0,
        :pm10_index  => stationIndexes.select { |index_value| index_value["pm10IndexLevel"] != nil }.dig(0, "pm10IndexLevel"),
        :pm10_value => stationValues.select { |sensor_value| sensor_value["3_value"] != nil }.dig(0, "3_value"),
        :pm10_date => 0,
        :c6h6_index => stationIndexes.select { |index_value| index_value["c6h6IndexLevel"] != nil }.dig(0, "c6h6IndexLevel"),
        :c6h6_value => stationValues.select { |sensor_value| sensor_value["10_value"] != nil }.dig(0, "10_value"),
        :c6h6_date => 0,
        :no2_index => stationIndexes.select { |index_value| index_value["no2IndexLevel"] != nil }.dig(0, "no2IndexLevel"),
        :no2_value => stationValues.select { |sensor_value| sensor_value["6_value"] != nil }.dig(0, "6_value"),
        :no2_date => 0,
        :pm25_index => stationIndexes.select { |index_value| index_value["pm25ndexLevel"] != nil }.dig(0, "pm25ndexLevel"),
        :pm25_value => stationValues.select { |sensor_value| sensor_value["69_value"] != nil }.dig(0, "69_value"),
        :pm25_date => 0,
        :o3_index => stationIndexes.select { |index_value| index_value["o3IndexLevel"] != nil }.dig(0, "o3IndexLevel"),
        :o3_value => stationValues.select { |sensor_value| sensor_value["5_value"] != nil }.dig(0, "5_value"),
        :o3_date => 0,
        :so2_index => stationIndexes.select { |index_value| index_value["so2IndexLevel"] != nil }.dig(0, "so2IndexLevel"),
        :so2_value => stationValues.select { |sensor_value| sensor_value["1_value"] != nil }.dig(0, "1_value"),
        :so2_date => 0,
        :station => station.number
      )
    end
  end
end

def build_import_gios_measur
  giosCrawler = GiosMeasurmentApiCrawler.new
  giosCrawler.downloadValues
  giosCrawler.downloadIndexes
  giosCrawler.createRecordInDb
end
