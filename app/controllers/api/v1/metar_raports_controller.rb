class Api::V1::MetarRaportsController < ApplicationController
  respond_to :json

  def index
    @metar_stations_count = MetarStation.all.count
    @metar_raports = MetarRaport.order("created_at").last(@metar_stations_count)
  end

end
