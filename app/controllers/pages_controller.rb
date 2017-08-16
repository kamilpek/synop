class PagesController < ApplicationController
  def home
    @stations = Station.all
    @date = Measurement.pluck(:date).last
    @hour = Measurement.pluck(:hour).last
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @measur_id = Measurement.where(station_number:station.number).pluck(:id).last
      @temperature = Measurement.where(station_number:station.number).pluck(:temperature).last
      @information = "#{station.name} – #{@temperature} C"
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

  def stats
  end

  def about
  end
end
