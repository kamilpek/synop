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
    end
  end

  def stats
  end

  def about
  end
end
