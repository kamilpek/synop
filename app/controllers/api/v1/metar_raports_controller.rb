class Api::V1::MetarRaportsController < ApplicationController
  respond_to :json

  def index
    @metar_raports = MetarRaport.where(id:1).last(1)
    MetarStation.all.each do |station|
      @metar_raports += MetarRaport.where(station:station.number).last(1)
    end
    #@metar_stations_count = MetarStation.all.count
    #@metar_raports = MetarRaport.order("created_at").last(@metar_stations_count)
  end

end
