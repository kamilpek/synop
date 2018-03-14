class Api::V1::MetarStationsController < ApplicationController
  respond_to :json

  def index
    @metar_stations = MetarStation.all
  end

end
