class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:about]

  def measurements
    @stations = Station.all
    @date = Measurement.order("created_at").pluck(:date).last
    @hour = Measurement.order("created_at").pluck(:hour).last
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @measur_id = Measurement.where(station_number:station.number).order("created_at").pluck(:id).last
      @temperature = Measurement.where(station_number:station.number).order("created_at").pluck(:temperature).last
      @information = "#{station.name}: #{@temperature} C"
      marker.lat station.latitude
      marker.lng station.longitude
      marker.infowindow render_to_string(:partial => "infowindow", :locals => { :object => @measur_id, :name => @information})
      marker.picture({
                      :url    => "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png",
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32, # Scaled width is half of the retina resolution; optional
                      :scaledHeight => 32, # Scaled width is half of the retina resolution; optional
                     })
    end
  end

  def forecast
    @stations = Station.all
    @date = Forecast.order("created_at").pluck(:date).last
    @hour = Forecast.order("created_at").pluck(:hour).last
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @forecast_id = Forecast.where(station_number:station.number).order("created_at").pluck(:id).last
      @forecast = Forecast.where(id:@forecast_id).order("created_at").last
      @temperatures = Forecast.where(station_number:station.number).order("created_at").pluck(:temperatures).last
      @information = "#{station.name} – przejdź po więcej informacji"
      marker.lat station.latitude
      marker.lng station.longitude
      marker.infowindow render_to_string(:partial => "infowindow_forecast", :locals => { :object => @forecast_id, :forecast => @forecast, :name => @information})
      marker.picture({
                      :url    => "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png",
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32, # Scaled width is half of the retina resolution; optional
                      :scaledHeight => 32, # Scaled width is half of the retina resolution; optional
                     })
    end
  end

  def metar
    @stations = MetarStation.where(number:MetarRaport.all.pluck(:station))
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @metar_raport_id = MetarRaport.where(station:station.number).order(:created_at).pluck(:id).last
      @metar_raport = MetarRaport.find(@metar_raport_id)
      marker.lat station.latitude
      marker.lng station.longitude
      marker.infowindow render_to_string(:partial => "infowindow_metar", :locals => { :object => @metar_raport_id, :metar_raport => @metar_raport, :name => @information})
      marker.picture({
                      :url    => "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png",
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32, # Scaled width is half of the retina resolution; optional
                      :scaledHeight => 32, # Scaled width is half of the retina resolution; optional
                     })
    end
  end

  def gios
    @stations_number = GiosMeasurment.all.pluck(:station)
    @stations = GiosStation.where(number:@stations_number)
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @gios_measur_id = GiosMeasurment.where(station:station.number).pluck(:id).last
      @gios_measurment = GiosMeasurment.find(@gios_measur_id)
      marker.lat station.latitude
      marker.lng station.longitude
      marker.infowindow render_to_string(:partial => "infowindow_gios", :locals => { :object => @gios_measur_id, :gios_measurment => @gios_measurment, :name => @information})
      marker.picture({
                      :url    => "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png",
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32, # Scaled width is half of the retina resolution; optional
                      :scaledHeight => 32, # Scaled width is half of the retina resolution; optional
                     })
      end
  end

  def gw
    @stations_number = GwMeasur.all.pluck(:gw_station_id)
    @stations = GwStation.where(id:@stations_number)
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @type = 1
      @gw_measur_id = GwMeasur.where(gw_station_id:station.id).order(:created_at).pluck(:id).last
      @gw_measurment = GwMeasur.find(@gw_measur_id)
      @gw_measur_second_id = GwMeasur.where(gw_station_id:station.id).order(:created_at).pluck(:id).second_to_last
      @gw_measurment_second = GwMeasur.find(@gw_measur_second_id)
      @image = "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png" if @gw_measurment.rain
      if @gw_measurment.water
        @type = 2
        @image = "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1533547330/bluetraingle_nqxfq5.png"
        if station.level_normal
          case @gw_measurment.water
          when 0..(station.level_normal.to_i/2) # niski
            @level = 1
            @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1534177339/blue_traingle_uzugp2.png" # Niebieski
          when (station.level_normal.to_i/2)..station.level_normal # średni
            @level = 2
            @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1534177339/green_traingle_bcsd1y.png" # Zielony
          when (station.level_max.to_i/2)..station.level_max # wysoki
            @level = 3
            @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1534177339/yellow_traingle_xzsthb.png" # Żółty
          when station.level_max..(station.level_max+station.level_rise) # ostrzegawczy
            @level = 4
            @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1534177339/orange_traingle_kdztwa.png" # Pomarańczowy
          when (station.level_max+station.level_rise)..1000 # alarmowy
            @level = 5
            @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1534177339/red_traingle_jwjgx3.png" # Czerwony
          else
            @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1534177339/black_traingle_btmgkp.png" # Czarny
          end
        end
      end
      marker.lat station.lat
      marker.lng station.lng
      marker.infowindow render_to_string(:partial => "infowindow_gw", :locals => {
        :object => @gw_measur_id,
        :gw_measurment => @gw_measurment,
        :gw_measurment_second => @gw_measurment_second,
        :type => @type,
        :level => @level,
        :station => station
        })
      marker.picture({
                      :url    => @image,
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32, # Scaled width is half of the retina resolution; optional
                      :scaledHeight => 32, # Scaled width is half of the retina resolution; optional
                     })
    end
  end

  def lightings
    # https://dane.imgw.pl/datastore/getfiledown/Oper/Perun/1min_secondaire/safir180825-101400.txt
    perun_data = Array.new
    file = "https://dane.imgw.pl/datastore/getfiledown/Oper/Perun/1min_secondaire/safir#{(DateTime.now.utc - 3.minutes).strftime("%y%m%d-%H%M")}00.txt"
    perun = open(file).read.split("\r\n")
    perun.each { |p| perun_data.push(p.split(";"))}
    @hash = Gmaps4rails.build_markers(perun_data) do |perun, marker|
      marker.lat (perun[5].to_f * 0.0001) #szerokość
      marker.lng (perun[6].to_f * 0.0001) #długość
      case perun[2].to_i
      when (1..4)
        @type = "1"
      when (5..9)
        @type = "2"
      when (10..14)
        @type = "3"
      when (15..19)
        @type = "4"
      when (20..24)
        @type = "5"
      when (25..29)
        @type = "6"
      when (30..34)
        @type = "7"
      when (35..39)
        @type = "8"
      when (40..44)
        @type = "9"
      when (45..49)
        @type = "10"
      when (50..1000)
        @type = "11"
      else
        @type = "1"
      end
      @image = "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png"
      if perun[7].to_i.between?(0, 3) #trójkąt
        @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1535203660/trojkat_#{@type}.png"
      elsif perun[7].to_i.between?(4, 5) #piorun
        @image = "https://res.cloudinary.com/traincms-herokuapp-com/image/upload/v1535203602/piorun_#{@type}.png"
      end
      marker.picture({
                      :url    => @image,
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32,
                      :scaledHeight => 32,
                     })
    end
  end

  def radars
    @radar = Radar.last
    date = Time.now.utc.strftime("%Y%m%d")
    hour = Time.now.utc.strftime("%H") + ((((Time.now.utc.strftime("%M").to_s.first).to_i*6)-1)%5).to_s + 0.to_s
    @radar_0 = 'https://meteomodel.pl/radar/cappi.png'
    @radar_1 = 'https://meteomodel.pl/radar/cmax.png'
    @radar_2 = 'https://meteomodel.pl/radar/eht.png'
    @radar_3 = 'https://meteomodel.pl/radar/pac.png'
    @radar_4 = 'https://meteomodel.pl/radar/zhail.png'
    @radar_5 = 'https://meteomodel.pl/radar/hshear.png'  
    @radar_6 = "https://danepubliczne.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_SRI.comp.sri/#{date}#{hour}0000dBR.sri.png"
    @radar_7 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000avg_sri.rtr.png"
    @radars = [@radar_1, @radar_2, @radar_3, @radar_4, @radar_5, @radar_6, @radar_7]
  end

  def radars_wrn
    response = RestClient.post 'https://dane.imgw.pl/datastore/getFilesList', {path: '/Oper/Polrad/Produkty/GDA/GDA_125_ZVW_vol_PAZP.wrn', productType: 'oper'}
    wrn_html = Nokogiri::HTML(response.body)
    li_collection = wrn_html.css('div').css('ul').css('li')
    li_size = li_collection.count()
    @radars = []

    for i in (li_size-25)..(li_size-1)
      if li_collection[i].css('a')[0]['href'].include? "png"
        @radars << 'https://dane.imgw.pl/' + li_collection[i].css('a')[0]['href']
      end
    end
  end
  
  def radars_rtr
    response = RestClient.post 'https://dane.imgw.pl/datastore/getFilesList', {path: '/Oper/Polrad/Produkty/GDA/gda.rtr', productType: 'oper'}
    rtr_html = Nokogiri::HTML(response.body)
    li_collection = rtr_html.css('div').css('ul').css('li')
    li_size = li_collection.count()
    @radars = []

    for i in (li_size-25)..(li_size-1)
      if li_collection[i].css('a')[0]['href'].include? "png"
        @radars << 'https://dane.imgw.pl/' + li_collection[i].css('a')[0]['href']
      end
    end
  end
  
  def radars_vvp
    response = RestClient.post 'https://dane.imgw.pl/datastore/getFilesList', {path: '/Oper/Polrad/Produkty/GDA/gda.vvp', productType: 'oper'}
    vvp_html = Nokogiri::HTML(response.body)
    li_collection = vvp_html.css('div').css('ul').css('li')
    li_size = li_collection.count()
    @radars = []

    for i in (li_size-25)..(li_size-1)
      if li_collection[i].css('a')[0]['href'].include? "png"
        @radars << 'https://dane.imgw.pl/' + li_collection[i].css('a')[0]['href']
      end
    end
  end
  
  def radars_ppi
    response = RestClient.post 'https://dane.imgw.pl/datastore/getFilesList', {path: '/Oper/Polrad/Produkty/GDA/gda_0_5.ppi', productType: 'oper'}
    ppi_html = Nokogiri::HTML(response.body)
    li_collection = ppi_html.css('div').css('ul').css('li')
    li_size = li_collection.count()
    @radars = []

    for i in (li_size-25)..(li_size-1)
      if li_collection[i].css('a')[0]['href'].include? "png"
        @radars << 'https://dane.imgw.pl/' + li_collection[i].css('a')[0]['href']
      end
    end
  end
  
  def radars_swi
    response = RestClient.post 'https://dane.imgw.pl/datastore/getFilesList', {path: '/Oper/Polrad/Produkty/GDA/gda_100.swi', productType: 'oper'}
    swi_html = Nokogiri::HTML(response.body)
    li_collection = swi_html.css('div').css('ul').css('li')
    li_size = li_collection.count()
    @radars = []

    for i in (li_size-25)..(li_size-1)
      if li_collection[i].css('a')[0]['href'].include? "png"
        @radars << 'https://dane.imgw.pl/' + li_collection[i].css('a')[0]['href']
      end
    end
  end

  def rtr
    date = Time.now.utc.strftime("%Y%m%d")
    hour = Time.now.utc.strftime("%H") + ((((Time.now.utc.strftime("%M").to_s.first).to_i*6)-1)%5).to_s + 0.to_s
    @top0 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top0.rtr.png"
    @top1 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top1.rtr.png"
    @top2 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top2.rtr.png"
    @top3 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top3.rtr.png"
    @top4 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top4.rtr.png"
    @top5 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top5.rtr.png"
    @top6 = "https://dane.imgw.pl/datastore/getfiledown/Oper/Polrad/Produkty/POLCOMP/COMPO_RTR.rtr/#{date}#{hour}0000top6.rtr.png"
  end

  def um
    hour_um
  end

  def coamps
    hour_coamps
  end

  def coamps_ground
    hour_coamps
  end

  def hour_um
    doc = HTTParty.get("http://new.meteo.pl/um/php/pict_show.php?cat=0&time=0")
    @parse_page ||= Nokogiri::HTML(doc)
    @datetime = DateTime.parse(@parse_page.css('font').text[6..-1])
    @date = @datetime.strftime("%Y%m%d")
    @hour = @datetime.strftime("%H")
  end

  def hour_coamps
    doc = HTTParty.get("http://coamps.icm.edu.pl/")
    @parse_page ||= Nokogiri::HTML(doc)
    @datetime = DateTime.parse(@parse_page.css('font').text)
    @date = @datetime.strftime("%Y%m%d")
    @hour = @datetime.strftime("%H")
  end

  def stats
  end

  def about
  end

  def alerts
    @alerts = Alert.where("time_from < ?", DateTime.now).where("time_for > ?", DateTime.now)
    @clients = Client.where(status:1)
  end

  # def alaro
  #   @parameters = {"Temperatura 2m" => "T2M", "Temperatura maksymalna 2m" => "TMAX", "Temperatura minimalna 2m" => "TMIN",
  #       "Temperatura 850hPa" => "T850", "Ciśnienie zredukowane do poziomu morza" => "MSLP", "Narastająca suma opadu" => "APCP",
  #       "Narastająca suma opadu konwekcyjnego" => "APCPC", "Narastająca suma opadu śneigu" => "SNOL", "Narastająca suma opadu śniegu konwekcyjnego" => "SNOC",
  #       "Prędkość wiatru 10m" => "WIND10", "Zachmurzenie piętra niskiego" => "CL", "Zachmurzenie piętra średniego" => "CM",
  #       "Zachmurzenie piętra wysokiego" => "CH"}
  # end

  # def arome
  #   @parameters = {"Temperatura 2m" => "T2M", "Temperatura maksymalna 2m" => "TMAX", "Temperatura minimalna 2m" => "TMIN",
  #       "Temperatura 850hPa" => "T850", "Ciśnienie zredukowane do poziomu morza" => "MSLP",
  #       "Prędkość wiatru 10m" => "WIND10", "Zachmurzenie piętra niskiego" => "CL", "Zachmurzenie piętra średniego" => "CM",
  #       "Zachmurzenie piętra wysokiego" => "CH"}
  # end
end
