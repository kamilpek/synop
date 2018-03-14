class Api::V1::GiosStationsController < ApplicationController
  respond_to :json

  def index
    @gios_stations = GiosStation.all
  end

end
