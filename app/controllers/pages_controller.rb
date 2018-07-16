class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:about]

  def home
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
    @stations_number = MetarRaport.all.pluck(:station)
    @stations = MetarStation.where(number:@stations_number)
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @metar_raport_id = MetarRaport.where(station:station.number).pluck(:id).last
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

  def radars
    @radar = Radar.last
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
end
